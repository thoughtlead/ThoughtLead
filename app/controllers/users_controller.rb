class UsersController < ApplicationController
  
  before_filter :login_required, :except => [ :signup, :changed_on_spreedly, :index ]
  before_filter :community_is_active
  before_filter :logged_in_as_owner?, :only => [ :disable, :reactivate]
  skip_before_filter :verify_authenticity_token, :only => :changed_on_spreedly
  before_filter :check_disabled
  
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
    return unless @user.update_attributes(params[:user])
    
    flash[:notice] = "Password saved."
    redirect_to edit_user_url(@user)
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
    
    redirect_to "https://spreedly.com/#{site.url_suffix}/subscribers/#{current_user.id}/subscribe/#{params[:selected_plan]}/#{current_user.login}"
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
    @user.disabled = true
    @user.save
    redirect_to @user
  end
  
  def reactivate
    @user = User.find(params[:id])
    @user.disabled = false
    @user.save
    redirect_to @user
  end
  
  private
  
  #what is this doing here?
  #TODO remove
  #  def plan_id
  #    case params[:selected_plan]
  #      when 'monthly' then '58'
  #      when 'quarterly' then '59'
  #      when 'yearly' then '60'
  #    end
  #  end
  
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
  
end
