module AuthenticatedSystem
  protected

  def logged_in?
    !!current_user
  end

  def logged_in_as_owner?
    logged_in? && current_user.owner?
  end

  def logged_in_as_super_admin?
    logged_in? && current_user.super_admin?
  end

  def logged_in_as_active?
    logged_in? && current_user.active?
  end

  def current_user_can_post?
    return logged_in? && (logged_in_as_owner? || current_user.can_post)
  end

  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
  end

  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
  end

  def login_required
    logged_in? || access_denied
  end

  def owner_login_required
    return access_denied unless logged_in?
    return true if current_user.owner?

    flash[:warning] = "You do not have permission to access that part of the site."
    redirect_to login_url
  end

  def super_admin_login_required
    return access_denied unless logged_in?
    return true if current_user.super_admin?

    flash[:warning] = "You do not have permission to access that part of the site."
    redirect_to login_url
  end

  def access_denied
    respond_to do |format|
      format.html do
        store_location
        flash[:warning] = "You do not have permission to access that part of the site."
        redirect_to login_url
      end
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def invalidate_return_to
    session[:return_to] = nil
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?, :logged_in_as_owner?, :logged_in_as_super_admin?, :logged_in_as_active?, :current_user_can_post?
  end

  private

  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def login_from_basic_auth
    authenticate_with_http_basic do |username, password|
      self.current_user = User.authenticate(username, password)
    end
  end

  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
      self.current_user = user
    end
  end
end
