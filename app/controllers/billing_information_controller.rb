class BillingInformationController < ApplicationController
  before_filter :login_required, :subscription_required, :load_subscription

  def edit
  end

  def update
    @card = ActiveMerchant::Billing::CreditCard.new(params[:card])
    @address = SubscriptionAddress.new(params[:address])

    @address.first_name = @card.first_name
    @address.last_name = @card.last_name
    if @card.valid? && @address.valid?
      if @subscription.store_card(@card, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
        message = "Congratulations on becoming a #{@subscription.access_class.name} member! You now have access to members-only content and discussions on the site."
        flash[:notice] = message
        redirect_to user_url(current_user) and return
      end
    end

    render :action => "edit"
  end

  protected

  def subscription_required
    redirect_to user_url(current_user) if current_user.subscription.blank?
  end

  def load_subscription
    @subscription = current_user.subscription
  end
end
