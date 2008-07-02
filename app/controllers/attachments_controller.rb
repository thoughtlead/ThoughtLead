class AttachmentsController < ApplicationController
  
  before_filter :owner_login_required
  before_filter :community_is_active
  
  def destroy
    Attachment.find_by_id(params[:id]).destroy
    flash[:notice] = "Deleted the attachment"
    redirect_to request.referer # send them back where they came from (possibly lessons or articles)
  end
    
end
