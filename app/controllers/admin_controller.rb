class AdminController < ApplicationController
  
  
  def handle_form(flash_notice)
    @community = current_community
    
    return if request.get?
    
    return unless @community.update_attributes(params[:community])
    
    flash[:notice] = flash_notice
    redirect_to community_dashboard_url
  end
  
  def edit_community
    handle_form("Saved community setttings")
  end
  
  def access_rights
    handle_form("Saved access setttings")
  end
  
end
