class CoursesController < ApplicationController
  
  before_filter :owner_login_required, :except => [ :index, :show ]
  
  def index
    @courses = current_community.courses
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
    @course = Course.find(params[:id])
    return render(:action => :edit) unless @course.update_attributes(params[:course])
    
    flash[:notice] = "Successfully saved"
    redirect_to @course
  end
  
  def edit
    @course = current_community.courses.find(params[:id])
  end

  def show
    @course = current_community.courses.find(params[:id])
  end
  
  def add_chapter
    @course = current_community.courses.find(params[:id])
    @course.chapters << Chapter.new(:name => params[:chapter_name])
    
    redirect_to @course
  end
  
end
