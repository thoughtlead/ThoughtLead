class ResponsesController < ApplicationController
  
  before_filter :login_required
  before_filter :community_is_active

  def create
    @discussion = current_community.discussions.find(params[:discussion_id])
    @discussion_response = Response.new(params[:response])
    @discussion_response.user = current_user
    
    return render(:template => 'discussions/show') unless @discussion_response.valid?
    
    @discussion.responses << @discussion_response
    
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
  
end
