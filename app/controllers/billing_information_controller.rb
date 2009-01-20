class BillingInformationController < ApplicationController
  before_filter :login_required, :subscription_required, :load_subscription

  def edit
  end

  def update
    @card = ActiveMerchant::Billing::CreditCard.new(params[:creditcard])
    @address = SubscriptionAddress.new(params[:address])

    @address.first_name = @card.first_name
    @address.last_name = @card.last_name
    if @card.valid? && @address.valid?
      if @subscription.store_card(@card, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
        flash[:notice] = "Your billing information has been updated."
        redirect_to user_url(current_user)
      end
    end
  end

  protected

  def subscription_required
    redirect_to user_url(current_user) if current_user.subscription.blank?
  end

  def load_subscription
    @subscription = current_user.subscription
  end
end
