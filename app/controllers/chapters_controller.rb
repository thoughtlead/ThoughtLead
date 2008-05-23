class ChaptersController < ApplicationController

  before_filter :owner_login_required
  
  def create
    @course = current_community.courses.find(params[:course_id])
    @chapter = Chapter.new(params[:chapter])
  
    return render(:template => 'courses/show') unless @chapter.valid?
    
    @course.chapters << @chapter
    
    flash[:notice] = "Successfully created"
    redirect_to course_chapters_url(@course)
  end

  def index
    @course = current_community.courses.find(params[:course_id])
    @chapters = @course.chapters
  end
  
  def destroy
    @course = current_community.courses.find(params[:course_id])
    @chapter = @course.chapters.find(params[:id])
    
    @chapter.destroy
    
    flash[:notice] = "Successfully deleted the chapter named '#{@chapter}'"
    redirect_to course_chapters_url(@course)
  end

end
