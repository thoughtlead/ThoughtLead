class AttachmentsController < ApplicationController
  
  before_filter :load_course_and_chapter_and_lesson
  before_filter :owner_login_required
  before_filter :community_is_active
  
  def destroy
    Attachment.find_by_id(params[:id]).destroy
    flash[:notice] = "Deleted the attachment"
    redirect_to [@course, @chapter, @lesson]
  end
  
  private  
  def load_course_and_chapter_and_lesson
    @course = current_community.courses.find(params[:course_id])
    @chapter = @course.chapters.find(params[:chapter_id])
    @lesson = @chapter.lessons.find(params[:lesson_id])
  end
  
end
