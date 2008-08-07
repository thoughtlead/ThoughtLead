class AdminController < ApplicationController

  before_filter :owner_login_required
  
  def edit_community
    @community = current_community
    
    return if request.get?
    
    return unless @community.update_attributes(params[:community])
    
    flash[:notice] = "Community Settings Saved"
    redirect_to community_dashboard_url
  end
  
  def access_rights
    @community = current_community
    
    return if request.get?
    
    return unless @community.update_attributes(params[:community])
    
    flash[:notice] = "Access Rights Saved"
    redirect_to community_home_url
  end
  
end
