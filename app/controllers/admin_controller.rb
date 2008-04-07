class AdminController < ApplicationController
  
  def edit_community
    @community = current_community
    
    return if request.get?
    return unless @community.update_attributes(params[:community])
    
    flash[:notice] = "Saved community settings"
    redirect_to community_home_url
  end
  
end
