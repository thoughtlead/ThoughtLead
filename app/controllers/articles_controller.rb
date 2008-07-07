class ArticlesController < ApplicationController
  
  before_filter :owner_login_required, :except => [ :show, :index ]
  before_filter :community_is_active
  before_filter :user_has_correct_privileges
  
  uses_tiny_mce(tiny_mce_options)
  
  def index
    @articles = current_community.articles.for_category(params[:category])
    @category = Category.find_by_id(params[:category]) if params[:category] && params[:category] != 'nil'
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find_by_id(params[:id])
    @article.attributes = params[:article]
    @article.content.attributes = params[:content]
    
    return render(:action => :edit) unless @article.save && @article.content.save
    
    flash[:notice] = "Successfully saved"
    redirect_to @article
  end
  
  def show
    @article = Article.find(params[:id])
    owner_login_required if @article.content.draft? #is there a better home for me?
  end
  
  def new
    @article = Article.new
    @article.content = Content.new
    @category = Category.find_by_id(params[:category]) if params[:category] && params[:category] != 'nil'
  end
  
  def create
    @article = current_community.articles.build(params[:article])
    @article.content = Content.new(params[:content])
    @article.content.user = current_user
    
    return render(:action => :new) unless @article.content.save && @article.save
    
    flash[:notice] = "Successfully created"
    redirect_to library_url, :category => @category
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    
    flash[:notice] = "Deleted the article named '#{@article}'"
    redirect_to library_url
  end
  
  private
  
  def user_has_correct_privileges
    return true if !params[:id]
    article = Article.find_by_id(params[:id])
    if !article.accessible_to(current_user)
      access_denied
    end
    return true
  end  
  
end
