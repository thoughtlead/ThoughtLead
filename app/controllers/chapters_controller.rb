class ChaptersController < ApplicationController

  before_filter :owner_login_required
  
  def create
    @course = current_community.courses.find(params[:course_id])
    @chapter = Chapter.new(params[:chapter])
  
    return render(:template => 'courses/show') unless @chapter.valid?
    
    @course.chapters << @chapter
    
    flash[:notice] = "Successfully created"
    redirect_to @course
  end



end
