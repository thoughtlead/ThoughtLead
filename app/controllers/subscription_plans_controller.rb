class SubscriptionPlansController < ApplicationController
  before_filter :owner_login_required

  def index
    @access_class = AccessClass.find(params[:access_class_id])
    @subscription_plans = @access_class.subscription_plans

    @subscription_plan = SubscriptionPlan.new
  end

  def create
    @access_class = AccessClass.find(params[:access_class_id])
    @subscription_plans = @access_class.subscription_plans

    @subscription_plan = SubscriptionPlan.new(params[:subscription_plan])
    if @subscription_plan.save
      @access_class.subscription_plans << @subscription_plan
      @access_class.save
      
      flash[:notice] = "Subscription plan created successfully."
      redirect_to access_class_subscription_plans_url(@access_class)
    else
      render :action => "index"
    end
  end
end