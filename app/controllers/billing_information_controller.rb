class BillingInformationController < ApplicationController
  before_filter :login_required
  before_filter :build_user, :only => [:new, :create]
  before_filter :load_billing, :only => [ :new, :create, :billing, :paypal ]
  before_filter :load_subscription, :only => [ :billing, :plan, :paypal ]
  before_filter :load_discount, :only => [ :plans, :plan, :new, :create ]
  before_filter :build_plan, :only => [:new, :create]

  #ssl_required :billing, :cancel, :edit, :update
  #ssl_allowed :plans, :thanks, :canceled, :paypal

  def edit
  end

  def update
    if @account.needs_payment_info?
      @address.first_name = @creditcard.first_name
      @address.last_name = @creditcard.last_name
      @account.address = @address
      @account.creditcard = @creditcard
    end

    if @account.save
      flash[:domain] = @account.domain
      redirect_to :action => 'thanks'
    else
      render :action => 'edit'
    end

    # put payment info on subscription CC#, exp date,
    # put address in aubscription_address
    flash[:notice] = "yay credit cards!"
    redirect_to user_url(current_user)
  end

  def billing
    if request.post?
      if params[:paypal].blank?
        @address.first_name = @creditcard.first_name
        @address.last_name = @creditcard.last_name
        if @creditcard.valid? & @address.valid?
          if @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
            flash[:notice] = "Your billing information has been updated."
            redirect_to :action => "billing"
          end
        end
      else
        if redirect_url = @subscription.start_paypal(paypal_account_url, billing_account_url)
          redirect_to redirect_url
        end
      end
    end
  end

  # Handle the redirect return from PayPal
  def paypal
    if params[:token]
      if @subscription.complete_paypal(params[:token])
        flash[:notice] = 'Your billing information has been updated'
        redirect_to :action => "billing"
      else
        render :action => 'billing'
      end
    else
      redirect_to :action => "billing"
    end
  end

  def plan
    @plans = SubscriptionPlan.find(:all, :conditions => ['id <> ?', @subscription.subscription_plan_id], :order => 'amount desc').collect {|p| p.discount = @subscription.discount; p }
    if request.post?
      @old_plan = @subscription.subscription_plan
      @plan = SubscriptionPlan.find(params[:plan_id])
      if @subscription.update_attributes(:plan => @plan)
        flash[:notice] = "Your subscription has been changed."
        SubscriptionNotifier.deliver_plan_changed(@subscription)
        redirect_to :action => "plan"
      else
        @subscription.plan = @old_plan
      end
    end
  end

  def cancel
    if request.post? and !params[:confirm].blank?
      current_account.destroy
      self.current_user = nil
      reset_session
      redirect_to :action => "canceled"
    end
  end

  def thanks
    redirect_to :action => "plans" and return unless flash[:domain]
    # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
  end

  def dashboard
    render :text => 'Dashboard action, engage!', :layout => true
  end

  protected

    def load_object
      @obj = @account = current_account
    end

    def build_user
      @account.user = @user = User.new(params[:user])
    end

    def build_plan
      redirect_to :action => "plans" unless @plan = SubscriptionPlan.find_by_name(params[:plan])
      @plan.discount = @discount
      @account.plan = @plan
    end

    def redirect_url
      { :action => 'show' }
    end

    def load_billing
      @creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
      @address = SubscriptionAddress.new(params[:address])
    end

    def load_subscription
      @subscription = current_account.subscription
    end

    # Load the discount by code, but not if it's not available
    def load_discount
      if params[:discount].blank? || !(@discount = SubscriptionDiscount.find_by_code(params[:discount])) || !@discount.available?
        @discount = nil
      end
    end

    def authorized?
      %w(new create plans canceled thanks).include?(self.action_name) ||
      (self.action_name == 'dashboard' && logged_in?) ||
      admin?
    end

end
