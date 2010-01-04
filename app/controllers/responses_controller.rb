include DiscussionsHelper
class ResponsesController < ApplicationController
  before_filter :community_is_active
  uses_tiny_mce(tiny_mce_options)
  

  def create
    @discussion = current_community.discussions.find(params[:discussion_id])
    @discussion_response = Response.new(params[:response])
    @discussion_response.user = current_user
    @discussion_response.discussion = @discussion

    return redirect_to(@discussion) unless @discussion_response.valid?

    @discussion.responses << @discussion_response

    EmailSubscriptionMailer.deliver_discussion_updates(@discussion.subscribers, @discussion_response)

    flash[:notice] = "Successfully added the response."
    redirect_to @discussion
  end

  def destroy
    discussion_response = Response.find(params[:id])
    @discussion = discussion_response.discussion
    discussion_response.destroy

    flash[:notice] = "Successfully deleted the response."
    redirect_to @discussion
  end
  
  def edit
    @response = Response.find(params[:id])
    @discussion = @response.discussion
    unless @response && (current_user == @response.user)
      flash[:error] = "That isn't your response to edit."
      redirect_to @discussion and return
    end
    unless @response.editable_by?(current_user)
      flash[:error] = "That response is no longer editable."
      redirect_to @discussion and return
    end
  end
  
  def update
    @response = Response.find(params[:id])
    @discussion = @response.discussion
    
    if @response && (current_user == @response.user)
      if @response.update_attributes(params[:response])
        flash[:notice] = "Successfully updated your response."
        redirect_to @discussion and return
      end
    else
      flash[:error] = "This isn't your response to edit."
      redirect_to @discussion and return
    end
    return render(:action => :edit)
  end  

  private

  def get_access_controlled_object
    Response.find(params[:id]) if params[:id]
  end
end
