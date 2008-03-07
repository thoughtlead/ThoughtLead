
class ApplicationController < ActionController::Base
  helper :all

  include AuthenticatedSystem

  before_filter :login_from_cookie

  protect_from_forgery
  
end
