class LessonsController < ApplicationController
  
  before_filter :load_course_and_chapter
  before_filter :owner_login_required, :except => [ :show ]
  before_filter :community_is_active
  before_filter :user_has_correct_privileges
  
  uses_tiny_mce(tiny_mce_options)
  
  def new
    @lesson = Lesson.new
  end
  
  def create
    @lesson = @chapter.lessons.build(params[:lesson])
    @lesson.user = current_user
    
    return render(:action => :new) unless @lesson.save
    
    flash[:notice] = "Successfully created"
    redirect_to [@course, @chapter, @lesson]
  end
  
  def update
    @lesson = @chapter.lessons.find(params[:id])
    @lesson.attributes = params[:lesson]
    
    return render(:action => :edit) unless @lesson.save
    
    flash[:notice] = "Successfully saved"
    redirect_to [@course, @chapter, @lesson]
  end
  
  def edit
    @lesson = @chapter.lessons.find(params[:id])
  end
  
  def show
    @lesson = @chapter.lessons.find(params[:id])
    owner_login_required if(@lesson.draft || @lesson.chapter.draft || @lesson.chapter.course.draft) #is there a better home for me?
  end
  
  def destroy
    @lesson = @chapter.lessons.find(params[:id])
    @lesson.destroy
    
    flash[:notice] = "Deleted the lesson named '#{@lesson}'"
    redirect_to @course
  end
  
  private
  def load_course_and_chapter
    @course = current_community.courses.find(params[:course_id])
    @chapter = @course.chapters.find(params[:chapter_id])
  end
  def user_has_correct_privileges
    return true if !params[:id]
    lesson = Lesson.find_by_id(params[:id])
    if !lesson.accessible_to(current_user)
      access_denied
    end
    return true
  end  
  
end
