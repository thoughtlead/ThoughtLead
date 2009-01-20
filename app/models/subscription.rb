class Subscription < ActiveRecord::Base
  include RecurringPayment

  belongs_to :user
  belongs_to :subscription_plan
  belongs_to :access_class

  before_create :set_renewal_at
  before_destroy :destroy_gateway_record

  validates_numericality_of :amount, :greater_than => 0
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_inclusion_of :renewal_units, :in => units
  validates_inclusion_of :state, :in => ["pending", "active", "trial"]

  named_scope :trials_expiring_soon, lambda { |*args| { :conditions => { :state => 'trial', :next_renewal_at => (args.first || 7.days.from_now) } } }
  named_scope :due, lambda { |*args| { :conditions => { :state => 'active', :next_renewal_at => (args.first || Date.today) } } }

  def needs_billing_information?
    billing_id.blank?
  end

  def pending?
    self.state == "pending"
  end

  def active?
    self.state == "active"
  end

  def trial?
    self.state == "trial"
  end

  def plan=(plan)
    unless self.subscription_plan == plan
      [:amount, :renewal_period, :renewal_units, :access_class].each do |f|
        self.send("#{f}=", plan.send(f))
      end
      self.state = "pending"
      self.subscription_plan = plan
    end
  end

  def trial_days_left
    (self.next_renewal_at.to_i - Time.now.to_i) / 86400
  end

  def store_card(creditcard, gw_options = {})
    # Clear out payment info if switching to CC from PayPal
    destroy_gateway_record(paypal) if paypal?

    response = if billing_id.blank?
      gateway.store(creditcard, gw_options)
    else
      gateway.update(billing_id, creditcard, gw_options)
    end

    if response.success?
      self.card_number = creditcard.display_number
      self.card_expiration = "%02d-%d" % [creditcard.expiry_date.month, creditcard.expiry_date.year]
      update_billing_id(response.token)
    else
      errors.add_to_base(response.message)
      false
    end
  end

  def charge
    if amount == 0 || (@response = gateway.purchase(amount_in_pennies, self.billing_id)).success?
      update_attributes(:next_renewal_at => self.next_renewal_at.advance(:months => self.renewal_period), :state => 'active')
      subscription_payments.create(:account => account, :amount => amount, :transaction_id => @response.authorization) unless amount == 0
      true
    else
      errors.add_to_base(@response.message)
      false
    end
  end

  def start_paypal(return_url, cancel_url)
    if (@response = paypal.setup_authorization(:return_url => return_url, :cancel_return_url => cancel_url, :description => AppConfig['app_name'])).success?
      paypal.redirect_url_for(@response.params['token'])
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end

  def complete_paypal(token)
    if (@response = paypal.details_for(token)).success?
      if (@response = paypal.create_billing_agreement_for(token)).success?
        # Clear out payment info if switching to PayPal from CC
        destroy_gateway_record(cc) unless paypal?

        self.card_number = 'PayPal'
        self.card_expiration = 'N/A'
        set_billing
      else
        errors.add_to_base("PayPal Error: #{@response.message}")
        false
      end
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end

  def needs_payment_info?
    self.card_number.blank? && self.subscription_plan.amount > 0
  end

  def paypal?
    card_number == 'PayPal'
  end

  protected

  def update_billing_id(token)
    self.billing_id = token

    if pending?
      #TODO: handle trial
      if (response = gateway.purchase(amount_in_pennies, billing_id)).success?
        #TODO: fill in description
        user.subscription_payments << SubscriptionPayment.new(:amount => amount, :description => 'TODO', :transaction_id => response.authorization)
        user.save!
        self.state = 'active'
        self.next_renewal_at = Date.today.advance({renewal_units => renewal_period}.symbolize_keys)
        save!
      else
        errors.add_to_base(response.message)
        return false
      end
    end

    true
  end

  def amount_in_pennies
    (amount * 100).to_i
  end

  def set_renewal_at
    return if self.subscription_plan.nil? || self.next_renewal_at
    self.next_renewal_at = Time.now.advance(:months => self.renewal_period)
  end

  def gateway
    paypal? ? paypal : cc
  end

  def paypal
    @paypal ||=  ActiveMerchant::Billing::Base.gateway(:paypal_express_reference_nv).new(gateway_config)
  end

  def cc
    @cc ||= ActiveMerchant::Billing::Base.gateway(:authorize_net_cim).new(gateway_config)
  end

  def destroy_gateway_record(gw = gateway)
    return if billing_id.blank?
    gw.unstore(billing_id)
    self.card_number = nil
    self.card_expiration = nil
    self.billing_id = nil
  end

  def gateway_config
    {:login => user.community.gateway_login, :password => user.community.gateway_password}
  end
end
