class CommunitiesController < ApplicationController
  
  layout :community_layout
  
  def index
    @communities = Community.find(:all)
  end
  
  def new
    @community = Community.new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @community = Community.new(params[:community])

    @community.valid?
    return render(:action => :new) unless @user.valid? && @community.valid?
    
    @user.save
    @community.owner = @user
    @community.save
    Mailer.deliver_community_created(@community, community_dashboard_url(@community))
    
    flash[:notice] = "Successfully created your community."
    redirect_to community_dashboard_url(@community)
  end
  
  def show

  end
  
  private
    def community_layout
      params[:action] == 'new' ? 'home' : 'application'
    end
  
end
