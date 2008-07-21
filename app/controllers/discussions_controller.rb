class DiscussionsController < ApplicationController
  
  #TODO this could be incorporated into a refactored control_access where the controllers are responsible for is_premium and is_registered
  before_filter :login_required, :except => [ :index, :show]
  before_filter :community_is_active
  skip_before_filter :control_access, :only => [ :index ]
  
  def index
    @discussions = current_community.discussions.for_theme(params[:theme])
    @theme = Theme.find_by_id(params[:theme]) if params[:theme] && params[:theme] != 'nil'
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
    flash[:notice] = "Successfully deleted the discussion post."
    @discussion.destroy    
    redirect_to discussions_url
  end

  private
  #bogus warning, this function is called by a method obtained from application.rb (ruby craziness!)
  def get_access_controlled_object
    return Discussion.find(params[:id]) if params[:id]
    #TODO this is bad, replace it with a refactored control_access function where the controller is responsible for is_premium and is_registered 
    #(possibly using those functions from their models where appropriate)
    return Discussion.new(:title => "", :body => "", :community => current_community) #make sure all other functions are access controlled as well (except skipped ones of course)
  end
    
end
