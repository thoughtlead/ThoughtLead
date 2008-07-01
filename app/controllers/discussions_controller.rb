class DiscussionsController < ApplicationController
  
  before_filter :login_required, :except => [ :index, :show]
  before_filter :community_is_active
  before_filter :user_has_correct_privileges

  def user_has_correct_privileges
    return true if !params[:id]
    discussion = Discussion.find_by_id(params[:id])
    if !discussion.accessible_to(current_user)
      access_denied
    end
  end
  

  
  def index
    @discussions = current_community.discussions.for_category(params[:category])
    @category = Category.find_by_id(params[:category]) if params[:category] && params[:category] != 'nil'
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
  
  def destroy
    @discussion = current_community.discussions.find(params[:id])
    @discussion.destroy
    
    flash[:notice] = "Successfully deleted the discussion post."
    redirect_to discussions_url
  end
  
end
