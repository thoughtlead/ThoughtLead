
class ApplicationController < ActionController::Base
  helper :all

  include AuthenticatedSystem
  include ExceptionNotifiable
  include CommunityLocation

  before_filter :login_from_cookie

  protect_from_forgery
  
  
  private
    def community_is_active
      return redirect_to(community_need_to_activate_url) unless current_community.active
    end
    
end
