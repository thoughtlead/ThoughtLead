class ResponsesController < ApplicationController

  before_filter :login_required

  def create
    @discussion = current_community.discussions.find(params[:discussion_id])
    @response = Response.new(params[:response])
    @response.user = current_user
    
    return render(:template => 'discussions/show') unless @response.valid?
    
    @discussion.responses << @response
    
    flash[:notice] = "Successfully created"
    redirect_to @discussion
  end
  
end
