class CoursesController < ApplicationController
  
  before_filter :login_required, :except => [ :index, :show ]
  
  def index
    @courses = Course.find(:all)
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(params[:course])
    @course.user = current_user
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
    @course = Course.find(params[:id])
  end

  def show
    @course = Course.find(params[:id])
  end
  
  
end
