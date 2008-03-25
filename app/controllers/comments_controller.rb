class CommentsController < ApplicationController

  def create
    @discussion = current_community.discussions.find(params[:discussion_id])
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    
    return render(:template => 'discussions/show') unless @comment.valid?
    
    @discussion.comments << @comment
    
    flash[:notice] = "Successfully created"
    redirect_to @discussion
  end
  
end
