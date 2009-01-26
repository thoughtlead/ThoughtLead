class SubscriptionPaymentsController < ApplicationController
  helper AdminHelper, UsersHelper
  before_filter :owner_login_required

  def index
    @user = User.find(params[:user_id])
    @subscription_payments = @user.subscription_payments
  end
end
