class UsersController < ApplicationController
  
  before_filter :login_required, :except => [ :signup, :changed ]
  
  def signup
    @user = User.new(params[:user])
    @user.community = current_community
    
    return unless request.post? && @user.save
    
    self.current_user = @user
    redirect_back_or_default(root_url)
    flash[:notice] = "Thanks for signing up!  You have been logged in."
  end
  
  def show
    @user = current_community.users.find(params[:id])
  end
  
  def index
    @users = current_community.users
  end

end
