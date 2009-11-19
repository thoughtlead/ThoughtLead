class SubscriptionPlansController < ApplicationController
  helper AdminHelper
  before_filter :owner_login_required

  def index
    @access_class = AccessClass.find(params[:access_class_id])
    @subscription_plans = @access_class.subscription_plans

    @subscription_plan = SubscriptionPlan.new
  end

  def create
    @access_class = AccessClass.find(params[:access_class_id])
    @subscription_plans = @access_class.subscription_plans

    @subscription_plan = SubscriptionPlan.new(params[:subscription_plan].merge(:access_class => @access_class))
    if @subscription_plan.save
      flash[:notice] = "Subscription plan created successfully."
      redirect_to access_class_subscription_plans_url(@access_class)
    else
      render :action => "index"
    end
  end
  
  def toggle
    @community = current_community
    @access_class = current_community.access_classes.find(params[:access_class_id])
    @plan = @access_class.subscription_plans.find(params[:id])
    if @plan.toggle!(:activated)
      aktion = @plan.activated? ? "enabled" : "disabled"
      flash[:notice] = "Successfully #{aktion} \"#{@plan.name}\" subscription plan"
    end
    redirect_to :action => 'index'
  end
end