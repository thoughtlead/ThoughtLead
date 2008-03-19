class CommunitiesController < ApplicationController
  
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
    flash[:notice] = "Successfully created your community!  An email has been sent with some information about your account."
    flash.keep
    redirect_to community_dashboard_url(@community)
  end
  
  def show

  end
  
end
