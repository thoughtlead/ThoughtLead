class AttachmentsController < ApplicationController
  
  before_filter :owner_login_required
  before_filter :community_is_active
  
  def destroy
    a = Attachment.find_by_id(params[:id])
    if a.content.lesson
      return_to = [a.content.lesson.chapter.course,a.content.lesson.chapter,a.content.lesson] 
    elsif a.content.article     
      return_to = a.content.article 
    else
      #if this ever becomes a problem add an error message to this
      return_to = community_home_url
    end
    a.destroy
    flash[:notice] = "Deleted the attachment"
    redirect_back_or_default(return_to)
  end
end
