class ChaptersController < ApplicationController
  before_filter :load_objects
  before_filter :owner_login_required

  def sort
    params[:chapters].each_with_index do |id, index|
      Chapter.update_all(['position=?', index+1], ['id=?', id])
    end
    @chapters = @course.chapters
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    @course.chapters << @chapter

    return render(:template => 'courses/show') unless @chapter.valid?

    flash[:notice] = "Successfully created"
    redirect_to course_chapters_url(@course)
  end

  def index
    @chapters = @course.chapters
  end

  def destroy
    @chapter.destroy
    flash[:notice] = "Successfully deleted the chapter named '#{@chapter}'"

    redirect_to course_chapters_url(@course)
  end

  def edit
  end

  def update
    return render(:action => :edit) unless @chapter.update_attributes(params[:chapter])

    redirect_to course_chapters_url(@course)
  end

  def load_objects
    if params[:id]
      @chapter = current_community.chapters.find(params[:id])
      @course = @chapter.course
    else
      @course = current_community.courses.find(params[:course_id])
    end
  end
end
