
class ApplicationController < ActionController::Base
  helper :all

  include AuthenticatedSystem
  include ExceptionNotifiable

  before_filter :login_from_cookie

  protect_from_forgery
  
end
