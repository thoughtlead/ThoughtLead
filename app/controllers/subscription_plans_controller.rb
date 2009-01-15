class SubscriptionPlansController < ApplicationController
  before_filter :owner_login_required
  
  def index
    @subscription_plans = AccessClass.find(params[:access_class_id]).subscription_plans
  end
end