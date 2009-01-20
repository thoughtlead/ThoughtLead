class SubscriptionController < ApplicationController
  before_filter :login_required, :load_subscription

  def edit
    @access_classes = current_community.access_classes
  end

  def update
    plan_id = params[:subscription][:subscription_plan_id]

    if plan_id == 'Free'
      @subscription.destroy unless @subscription.blank?
      redirect_to user_url(current_user) and return
    end

    if @subscription.blank?
      @subscription = current_user.subscription = Subscription.new
    end

    @subscription.plan = SubscriptionPlan.find(plan_id)
    @subscription.save!

    if @subscription.needs_billing_information?
      redirect_to edit_billing_information_url
    else
      @subscription.ensure_activation
      flash[:notice] = "Successfully changed subscription."
      redirect_to user_url(current_user)
    end
  end

  protected

  def load_subscription
    @subscription = current_user.subscription
  end
end
