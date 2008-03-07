
class ApplicationController < ActionController::Base
  helper :all

  include AuthenticatedSystem

  protect_from_forgery
end
