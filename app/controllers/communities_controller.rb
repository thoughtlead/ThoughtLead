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
    
    # Going to do this on Monday!
    # @user.save
    # @community.owner = @user
    # @community.save
    redirect_to @community
    flash[:notice] = "Successfully created your community!  An email has been sent with some information about your account."
  end
  
  
end
