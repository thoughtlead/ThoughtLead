class UsersController < ApplicationController
  
  before_filter :login_required, :except => [ :signup, :changed ]
  
  def signup
    @user = User.new(params[:user])

    return unless request.post? && @user.save
    
    self.current_user = @user
    redirect_back_or_default(root_url)
    flash[:notice] = "Thanks for signing up!  You have been logged in."
  end
  
  def show
    @user = User.find(params[:id])
  end

end
