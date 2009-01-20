class SubscriptionController < ApplicationController
  before_filter :login_required

  def edit
    @subscription = current_user.subscription
    @access_classes = current_community.access_classes
  end

  def update
    plan_id = params[:subscription][:subscription_plan_id]
    if plan_id == 'Free'
      unless current_user.subscription.blank?
        current_user.subscription.destroy
      end
    else
      if current_user.subscription.blank?
        current_user.subscription = Subscription.new
      end
      current_user.subscription.plan = SubscriptionPlan.find(plan_id)
      current_user.subscription.save!
    end

    redirect_to :controller => 'billing_information', :action => 'edit'
  end
end
