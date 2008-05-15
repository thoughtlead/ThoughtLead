class UsersController < ApplicationController
  
  before_filter :login_required, :except => [ :signup, :changed_on_spreedly ]
  before_filter :community_is_active
  skip_before_filter :verify_authenticity_token, :only => :changed_on_spreedly
  
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
    @user.attributes = params[:user]
    return render(:action => :edit) unless @user.save_with_avatar
    
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
    return if current_community.spreedly_api_key.blank? || current_community.spreedly_community_name.blank?
    
    SubscriptionPlan.api_key = current_community.spreedly_api_key
    @subscription_plans = SubscriptionPlan.find(:all)
    
    return if request.get? || params[:selected_plan].blank?
    redirect_to "https://spreedly.com/#{current_community.spreedly_community_name}/subscribers/#{current_user.id}/subscribe/#{params[:selected_plan]}/#{current_user.login}"
  end
  
  def changed_on_spreedly
    subscriber_ids = params[:subscriber_ids].split(",")
    subscriber_ids.each do | each |
      user = current_community.users.find_by_id(each)
      user.refresh_from_spreedly if user
    end

    head(:ok)
  end
  

  private
    def plan_id
      case params[:selected_plan]
        when 'monthly' then '58'
        when 'quarterly' then '59'
        when 'yearly' then '60'
      end
    end

end
