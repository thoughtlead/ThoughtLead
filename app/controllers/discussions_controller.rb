class DiscussionsController < ApplicationController
  
  
  def index
    @discussions = current_community.discussions
  end

  def new
    @discussion = Discussion.new
  end
  
  def create
    @discussion = current_community.discussions.build(params[:discussion])
    @discussion.user = current_user
    
    return render(:action => :new) unless @discussion.save
    
    flash[:notice] = "Successfully created"
    redirect_to @discussion
  end

  def update
    @discussion = current_community.discussions.find(params[:id])
    
    return render(:action => :edit) unless @discussion.update_attributes(params[:discussion])
    
    flash[:notice] = "Successfully saved"
    redirect_to @discussion
  end
  
  def edit
    @discussion = current_community.discussions.find(params[:id])
  end

  def show
    @discussion = current_community.discussions.find(params[:id])
  end
  
  
end
