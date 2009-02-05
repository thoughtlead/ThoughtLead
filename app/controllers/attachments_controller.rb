class AttachmentsController < ApplicationController
  before_filter :owner_login_required
  before_filter :community_is_active

  def destroy
    @attachment = Attachment.find_by_id(params[:id])

    if @attachment.content.lesson
      return_to = @attachment.content.lesson
    elsif @attachment.content.article
      return_to = @attachment.content.article
    else
      #if this ever becomes a problem add an error message to this
      return_to = community_home_url
    end

    @attachment.destroy
    flash[:notice] = "Deleted the attachment"
    redirect_back_or_default(return_to)
  end
end
