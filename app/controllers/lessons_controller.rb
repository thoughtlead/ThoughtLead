class LessonsController < ApplicationController
  
  before_filter :load_course_and_chapter
  before_filter :owner_login_required, :except => [ :show ]
  before_filter :community_is_active
  
  uses_tiny_mce(:options => 
{    :mode => "textareas",
  	:theme => "advanced",
  	:theme_advanced_buttons1 => "bold,italic,|,bullist,numlist,outdent,indent,|,undo,redo",
  	:theme_advanced_buttons2 => "",
  	:theme_advanced_buttons3 => "",
  	:theme_advanced_toolbar_location => "top",
  	:theme_advanced_toolbar_align => "left",
    :extended_valid_elements => "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]"
}
  )
   
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
    
    return render(:action => :edit) unless @lesson.update_attributes(params[:lesson])
    
    flash[:notice] = "Successfully saved"
    redirect_to [@course, @chapter, @lesson]
  end
  
  def edit
    @lesson = @chapter.lessons.find(params[:id])
  end

  def show
    @lesson = @chapter.lessons.find(params[:id])
  end
  
  private
    def load_course_and_chapter
      @course = current_community.courses.find(params[:course_id])
      @chapter = @course.chapters.find(params[:chapter_id])
    end
  
end
