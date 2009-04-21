class ArticlesController < ApplicationController  
  before_filter :owner_login_required, :except => [ :show, :index ]
  before_filter :community_is_active
  before_filter :set_section_title

  uses_tiny_mce(tiny_mce_options)

  def index
    @articles = current_community.articles.for_category(params[:category])
    unless logged_in? && current_user.owner?
      @articles = @articles.find_all { |article| !article.content.draft }
    end
    @articles = @articles.sort_by{ |article| article.content.updated_at }
    @articles = @articles.reverse
    @articles = @articles.paginate :page => params[:page], :per_page => 20
    @category = current_community.categories.find_by_id(params[:category]) if params[:category] && params[:category] != 'nil'
  end

  def edit
    @article = current_community.articles.find(params[:id])
    set_headline :content => "Edit Article - #{@article}"
  end

  def update
    @article = current_community.articles.find_by_id(params[:id])
    @article.attributes = params[:article]
    @article.content.attributes = params[:content]

    return render(:action => :edit) unless @article.content.save && @article.save
    
    embed_video and return if params[:embed_video] 

    flash[:notice] = "Successfully saved"
    redirect_to @article
  end

  def show
    @article = current_community.articles.find(params[:id])
    owner_login_required if @article.content.draft? #is there a better home for me?
    set_headline :content => @article
  end

  def new
    @article = Article.new
    @article.content = Content.new
    @category = Category.find_by_id(params[:category]) if params[:category] && params[:category] != 'nil'   
    set_headline :content => "Add a new article" 
  end

  def create
    @article = current_community.articles.build(params[:article])
    @article.content = Content.new(params[:content])
    @article.content.user = current_user
    @article.content.article = @article

    return render(:action => :new) unless @article.content.save && @article.save

    embed_video and return if params[:embed_video] 

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
  
  def set_section_title
    set_headline :section => 'Library'
  end
  
  def embed_video
    @panda_video = Panda::Video.create
    @video = @article.content.attachments.build(:user => current_user, :embedded => true, :panda_id => @panda_video.id)
    unless @video.save_without_validation
      render :text => @video.inspect, :layout => false
    else
      flash[:notice] = "Ready to upload your video"
      redirect_to media_upload_url(:id => @video.id)
    end
  end
  
  def get_access_controlled_object
    Article.find(params[:id]) if params[:id]
  end
end
