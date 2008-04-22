class UsersController < ApplicationController
  
  before_filter :login_required, :except => [ :signup, :changed ]
  before_filter :community_is_active
  
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

  def edit
    @user = current_community.users.find(params[:id])
    if @user != current_user
      flash[:warning] = "You do not have the privileges to reach that part of the site"
      redirect_to login_url
    end
  end

  def update
    @user = current_user
    return render(:action => :edit) unless @user.update_attributes(params[:user])
    
    flash[:notice] = "Saved profile"
    redirect_to @user
  end
  
  def index
    @users = current_community.users
  end
  
  def email
    @send_to_user = current_community.users.find(params[:id])
    @email = Email.new(params[:email])
    return if request.get? || !@email.valid?
    
    Mailer.deliver_user_to_user_email(current_user, @send_to_user, @email)
    
    flash[:notice] = "Email sent to #{@send_to_user}"
    redirect_to @send_to_user
  end

end
