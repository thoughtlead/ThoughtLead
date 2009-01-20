class SessionController < ApplicationController
  skip_before_filter :invalidate_return_to, :only => [:new,:create]

  def new
  end

  def create
    self.current_user = current_community.authenticate(params[:login], params[:password])
    if logged_in?
      handle_remember_me
      redirect_back_or_default(community_home_url)
      flash[:notice] = "Logged in successfully"
    else
      flash.now[:error]= "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to(login_url)
  end

  private

  def handle_remember_me
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
    end
  end
end
