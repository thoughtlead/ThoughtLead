class ArticlesController < ApplicationController
  
  before_filter :login_required, :except => [ :show ]
  
  def new
    @course = Course.find(params[:course_id])
    @article = Article.new
  end
  
  def create
    @course = Course.find(params[:course_id])
    @article = @course.articles.build(params[:article])
    @article.user = current_user
  
    return render(:action => :new) unless @article.save
    
    flash[:notice] = "Successfully created"
    redirect_to [@course, @article]
  end

  def update
    @course = Course.find(params[:course_id])
    @article = @course.articles.find(params[:id])
    
    return render(:action => :edit) unless @article.update_attributes(params[:article])
    
    flash[:notice] = "Successfully saved"
    redirect_to [@course, @article]
  end
  
  def edit
    @course = Course.find(params[:course_id])
    @article = @course.articles.find(params[:id])
  end

  def show
    @course = Course.find(params[:course_id])
    @article = @course.articles.find(params[:id])
  end
  
end
