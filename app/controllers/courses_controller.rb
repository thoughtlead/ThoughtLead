class CoursesController < ApplicationController
  before_filter :load_objects
  before_filter :owner_login_required, :except => [ :index, :show ]
  before_filter :community_is_active
  before_filter :set_section_title, :except => :show

  uses_tiny_mce(tiny_mce_options)

  def sort
    params[:courses].each_with_index do |id, index|
      Course.update_all(['position=?', index+1], ['id=?', id])
    end
  end

  def index
    @courses = current_community.courses
    @themed_courses_sidebar = render_to_string(:file => themed_file("_courses_sidebar.html.erb")) 
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    @course.user = current_user
    @course.community = current_community

    return render(:action => :new) unless @course.save

    flash[:notice] = "Successfully created"
    redirect_to @course
  end

  def update
    return render(:action => :edit) unless @course.update_attributes(params[:course])

    flash[:notice] = "Successfully saved"
    redirect_to @course
  end

  def edit
    if @course
      set_headline :content => "Editing #{@course.title}"
    end
  end

  def show
    owner_login_required if @course.draft #is there a better home for me?
    if @course
      set_headline :content => @course.title
    end
  end

  def destroy
    @course.destroy
    flash[:notice] = "Successfully deleted the course named '#{@course}'"
    redirect_to courses_url
  end

  private
  
  def set_section_title
    set_headline :section => 'Courses'
  end

  def load_objects
    if params[:id]
      @course = current_community.courses.find(params[:id])
    end
  end
end
