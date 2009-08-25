class UsersController < ApplicationController
  before_filter :login_required, :except => [ :signup, :index, :forgot_password ]
  before_filter :community_is_active
  before_filter :logged_in_as_owner?, :only => [ :disable, :reactivate]
  skip_before_filter :invalidate_return_to, :only => [ :signup ]
  before_filter :check_disabled
  before_filter :set_section_title, :only => [:index, :show]

  def signup
    @user = User.new(params[:user])

    if request.post?
      @user.password = random_password(7)
      @user.password_confirmation = @user.password
      if User.find_by_login_or_email(@user.email).nil?
        @user.login = @user.email
      else
        @user.login = random_password(10)
      end
      @user.display_name = make_display_name @user
      @user.community = current_community
      @user.disabled = false
      if current_community.affiliates_enabled?
        if aff = cookies['TLAFF'] and referrer = User.find_by_affiliate_code(aff)
          @user.referred_by_id = referrer.id
          record_action(aff, :signup)
        end
      end
    end
    
    return unless request.post? && @user.save

    #send user account information
    Mailer.deliver_new_user_welcome(@user, @user.password, community_login_url(@user.community))

    #send the community owner notification
    Mailer.deliver_new_user_notice_to_owner(@user)

    # temporarily sign-in the new user
    self.current_user = @user
    
    #redirect to thank you/upsell page
    redirect_to community_upsell_path

    #flash user
    flash[:notice] = "Your account has been created. Check your email to retrieve your username and password."
  end

  def show
    @user = current_community.users.find_by_login_or_email(params[:id])
    @viewing_self = current_user == @user
    @title = @viewing_self ? "Your Profile" : @user.to_s
    @show_edit = @viewing_self || logged_in_as_owner?
    @show_disable = logged_in_as_owner? && !@user.owner?
    @show_change_billing = @viewing_self && !@user.subscription.blank? && !@user.owner? && current_community.uses_internal_billing
    set_headline :content => @user.display_name
  end

  def edit
    @user = current_community.users.find_by_login_or_email(params[:id])
    if @user.display_name.nil?
      unless @user.login == @user.email
        @user.display_name = @user.login
      else
        @user.display_name = make_display_name(@user)
      end
    end

    unless @user == current_user || logged_in_as_owner?
      flash[:warning] = "You do not have the privileges to reach that part of the site"
      redirect_to login_url
    end
  end

  def update
    @user = current_community.users.find_by_login_or_email(params[:id])
    @user.attributes = params[:user]
    return render(:action => :edit) unless @user.save
    
    # Clear out user's access classes if edited
    unless access_classes = params[:user][:access_class_ids] and !access_classes.empty?
      @user.access_classes.clear
    end
    
    flash[:notice] = "Saved profile"
    redirect_to @user
  end

  def index
    @users = current_community.users
    @users = @users.find_all { |user| !user.disabled? } unless logged_in_as_owner?
    @users = @users.paginate :page => params[:page], :per_page => 15
  end

  def edit_password
    @user = current_community.users.find_by_login_or_email(params[:id])
    if @user != current_user && !logged_in_as_owner?
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

    if user = current_community.users.find_by_login_or_email(params[:login])
      @new_password = random_password(20)
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
    @send_to_user = current_community.users.find_by_login_or_email(params[:id])
    @email = Email.new(params[:email])
    return if request.get? || !@email.valid?

    Mailer.deliver_user_to_user_email(current_user, @send_to_user, @email)

    flash[:notice] = "Email sent to #{@send_to_user}"
    redirect_to @send_to_user
  end

  def disable
    @user = current_community.users.find_by_login_or_email(params[:id])
    unless @user.owner?
      @user.disabled = true
      @user.save
    end
    redirect_to @user
  end

  def reactivate
    @user = current_community.users.find_by_login_or_email(params[:id])
    @user.disabled = false
    @user.save
    redirect_to @user
  end

  private
  
  def set_section_title
    set_headline :section => 'Member Directory'
  end

  def make_display_name(user)
    #first try to set it to "firstname lastname"
    tentative_display_name = user.first_name + " " + user.last_name
    if current_community.users.find_by_display_name(tentative_display_name).nil?
      return tentative_display_name
    end

    #then try "flastname""
    tentative_display_name = user.first_name.first + user.last_name
    if current_community.users.find_by_display_name(tentative_display_name).nil?
      return tentative_display_name
    end

    #then try "firstnamel"
    tentative_display_name = user.first_name + user.last_name.first
    if current_community.users.find_by_display_name(tentative_display_name).nil?
      return tentative_display_name
    end

    #then try "firstname lastname number" until one fits
    name = user.first_name + " " + user.last_name
    tentative_display_name = name
    index = 2
    until current_community.users.find_by_display_name(tentative_display_name).nil?
      tentative_display_name = name + " " + index.to_s
      index = index + 1
    end
    return tentative_display_name
  end

  def get_access_controlled_object
    return nil if params[:user_id].blank?

    return Class.new do
      def is_registered?
        true
      end

      def access_classes
        nil
      end
    end.new
  end

  def check_disabled
    return true if !params[:id]
      
    params[:id].gsub!('-','.')
    @user = current_community.users.find_by_login_or_email(params[:id])
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
