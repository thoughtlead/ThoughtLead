class SubscriptionController < ApplicationController
  helper AccessClassesHelper
  skip_before_filter :verify_authenticity_token, :only => [:edit]
  before_filter :login_required, :load_subscription

  def edit
    @access_classes = current_community.access_classes.active
  end

  def update
    plan_id = params[:subscription][:subscription_plan_id]

    if plan_id == 'free'
      @subscription.destroy unless @subscription.blank?
      redirect_to user_url(current_user) and return
    end

    if @subscription.blank?
      @subscription = current_user.subscription = Subscription.new
    end

    @subscription.plan = SubscriptionPlan.find(plan_id)
    @subscription.save!

    if @subscription.needs_billing_information? && !current_user.owner?
      redirect_to edit_billing_information_url(:secure => true)
    else
      if @subscription.ensure_activation
        flash[:notice] = "Congratulations on becoming a #{@subscription.access_class.name} member! You now have access to members-only content and discussions on the site."
      else
        flash[:notice] = "Subscription could not be activated, check your payment method. #{@subscription.errors.full_messages.join(", ")}"
      end
      redirect_to user_url(current_user)
    end
  end

  protected

  def load_subscription
    @subscription = current_user.subscription
  end
end
