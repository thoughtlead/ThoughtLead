class ArticlesController < ApplicationController
  
  before_filter :owner_login_required, :except => [ :show, :index ]
  before_filter :community_is_active
  
  uses_tiny_mce(tiny_mce_options)
  
  def index
    @articles = current_community.articles.for_category(params[:category])
    @articles = @articles.sort_by{ |article| article.content.updated_at }
    @articles = @articles.reverse
    @category = current_community.categories.find_by_id(params[:category]) if params[:category] && params[:category] != 'nil'
  end
  
  def edit
    @article = current_community.articles.find(params[:id])
  end
  
  def update
    @article = current_community.articles.find_by_id(params[:id])
    @article.attributes = params[:article]
    @article.content.attributes = params[:content]
    
    return render(:action => :edit) unless @article.content.save && @article.save
    
    flash[:notice] = "Successfully saved"
    redirect_to @article
  end
  
  def show
    @article = current_community.articles.find(params[:id])
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
    @article.content.article = @article
    
    return render(:action => :new) unless @article.content.save && @article.save
    
    flash[:notice] = "Successfully created"
    redirect_to library_url, :category => @category
  end
  
  def destroy
    @article = current_community.articles.find(params[:id])
    flash[:notice] = "Deleted the article named '#{@article}'"
    @article.destroy    
    redirect_to library_url
  end
  
  private
  #bogus warning, this function is called by a method obtained from application.rb (ruby craziness!)
  def get_access_controlled_object
    Article.find(params[:id]) if params[:id]
  end
  
end
