class EmailSubscriptionsController < ApplicationController

  before_filter :community_is_active

  def create
    @discussion = current_community.discussions.find(params[:discussion_id])
    @email_subscription = EmailSubscription.new
    @email_subscription.subscriber = current_user
    @email_subscription.discussion = @discussion
    @email_subscription.save

    flash[:notice] = "You will receive email updates whenever someone responds to this discussion"
    redirect_to @discussion
  end

  def destroy
    @old_email_subscription = EmailSubscription.find(params[:id])
    @discussion = @old_email_subscription.discussion
    @old_email_subscription.destroy

    flash[:notice] = "You will no longer receive email updates for this discussion"
    redirect_to @discussion
  end
end
