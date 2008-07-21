class ChaptersController < ApplicationController
  
  before_filter :owner_login_required
  
  def create
    @course = current_community.courses.find(params[:course_id])
    @chapter = Chapter.new(params[:chapter])
    @course.chapters << @chapter
    
    return render(:template => 'courses/show') unless @chapter.valid?    
    
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
    
    flash[:notice] = "Successfully deleted the chapter named '#{@chapter}'"
    @chapter.destroy
    
    redirect_to course_chapters_url(@course)
  end
  
  def edit
    @course = current_community.courses.find(params[:course_id])
    @chapter = @course.chapters.find(params[:id])    
  end
  
  def update
    @course = current_community.courses.find(params[:course_id])
    @chapter = @course.chapters.find(params[:id])    
    
    return render(:action => :edit) unless @chapter.update_attributes(params[:chapter])
    
    redirect_to course_chapters_url(@course)
  end
  
end
