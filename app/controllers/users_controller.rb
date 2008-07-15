class UsersController < ApplicationController
  
  before_filter :login_required, :except => [ :signup, :changed_on_spreedly, :index, :forgot_password, :upgrade ]
  before_filter :community_is_active
  before_filter :logged_in_as_owner?, :only => [ :disable, :reactivate]
  skip_before_filter :verify_authenticity_token, :only => :changed_on_spreedly
  before_filter :check_disabled
  before_filter :upgrade_login_check, :only => [:upgrade]
  
  def signup
    @user = User.new(params[:user])
    @user.community = current_community
    
    return unless request.post? && @user.save
    
    Mailer.deliver_new_user_welcome(@user)
    Mailer.deliver_new_user_notice_to_owner(@user)
    
    self.current_user = @user
    redirect_back_or_default(root_url)
    flash[:notice] = "Thanks for signing up!  You have been logged in and a welcome e-mail has been sent."
  end
  
  def show
    @user = current_community.users.find(params[:id])
  end
  
  def edit
    @user = current_community.users.find(params[:id])
    unless @user == current_user || logged_in_as_owner?
      flash[:warning] = "You do not have the privileges to reach that part of the site"
      redirect_to login_url
    end
  end
  
  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    return render(:action => :edit) unless @user.save
    
    flash[:notice] = "Saved profile"
    redirect_to @user
  end
  
  def index
    @users = current_community.users
  end
  
  def edit_password
    @user = current_community.users.find(params[:id])
    if @user != current_user
      flash[:warning] = "You do not have the privileges to reach that part of the site"
      redirect_to login_url
    end
    
    return if request.get?
    
    @user.password_required = true
    return unless @user.update_attributes(params[:user]) && @user.save
    
    flash[:notice] = "Password saved."
    redirect_to edit_user_url(@user)
  end  
  
  def forgot_password
    return if request.get?
    
    if user = User.find_by_login(params[:login])
      @new_password = random_password
      user.password = user.password_confirmation = @new_password
      user.save!
      Mailer.deliver_new_password(user, @new_password)
      
      flash[:notice] = "We sent a new password to the email address registered to #{user.login}."
      redirect_to community_home_url
    else
      flash[:notice] =  "We can't find that account.  Try again."
      redirect_to forgot_password_url
    end
  end
  
  def email
    @send_to_user = current_community.users.find(params[:id])
    @email = Email.new(params[:email])
    return if request.get? || !@email.valid?
    
    Mailer.deliver_user_to_user_email(current_user, @send_to_user, @email)
    
    flash[:notice] = "Email sent to #{@send_to_user}"
    redirect_to @send_to_user
  end
  
  def upgrade
    return if current_community.spreedly_api_key.blank?
    
    Spreedly::SubscriptionPlan.configure(current_community)
    @subscription_plans = Spreedly::SubscriptionPlan.find(:all)
    
    return if request.get? || params[:selected_plan].blank?
    
    Spreedly::Site.configure(current_community)
    site = Spreedly::Site.find(:one, :from => current_community.use_spreedly_production_site ? :production : :test)
    
    redirect_to "https://spreedly.com/#{site.url_suffix}/subscribers/#{current_user.id}/subscribe/#{params[:selected_plan]}/#{current_user.login}?return_url=#{session[:return_to]}"
  end
  
  def changed_on_spreedly
    subscriber_ids = params[:subscriber_ids].split(",")
    subscriber_ids.each do | each |
      user = current_community.users.find_by_id(each)
      user.refresh_from_spreedly if user
    end
    
    head(:ok)
  end
  
  def disable
    @user = User.find(params[:id])
    unless @user.owner?
      @user.disabled = true
      @user.save
    end
    redirect_to @user
  end
  
  def reactivate
    @user = User.find(params[:id])
    @user.disabled = false
    @user.save
    redirect_to @user
  end
  
  private
  
  #bogus warning, this function is called by a method obtained from application.rb (ruby craziness!)
  def get_access_controlled_object
    User.find(params[:id]) if params[:id]
  end
  
  #this may be a bogus warning, not sure?
  def plan_id
    case params[:selected_plan]
      when 'monthly' then '58'
      when 'quarterly' then '59'
      when 'yearly' then '60'
    end
  end
  
  def upgrade_login_check
    return if logged_in?
    store_location
    flash[:notice] = "You must log in before you upgrade."
    redirect_to login_url
  end
  
  def check_disabled
    return true if !params[:id]
    @user = User.find(params[:id])
    if @user.disabled? && !logged_in_as_owner? 
      flash[:warning] = "The user \"#{@user}\" has been disabled."
      if request.referer
        redirect_to request.referer # send them back where they came from
      else
        redirect_to login_url
      end
      return false
    end
    return true
  end
  
  def random_password( len = 20 )
    chars = (("a".."z").to_a + ("1".."9").to_a )- %w(i o 0 1 l 0)
    newpass = Array.new(len, '').collect{chars[rand(chars.size)]}.join
  end
  
end
