class ArticlesController < ApplicationController
  skip_before_filter :find_community, :only => [ :status, :done ]
  skip_before_filter :control_access, :only => [ :status, :done ]
  
  before_filter :owner_login_required, :except => [ :show, :index, :status, :done ]
  before_filter :community_is_active, :except => [ :status, :done ]


  uses_tiny_mce(tiny_mce_options)

  def index
    @articles = current_community.articles.for_category(params[:category])
    @articles = @articles.find_all { |article| !article.content.draft }
    @articles = @articles.sort_by{ |article| article.content.updated_at }
    @articles = @articles.reverse
    @articles = @articles.paginate :page => params[:page], :per_page => 20
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
    
    embed_video(@article.id) and return if params[:embed_video] 

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
    
    @media = Panda::Video.create
    @upload_form_url = %(http://#{Panda.api_domain}:#{Panda.api_port}/videos/#{@media.id}/form)
    
  end

  def create
    @article = current_community.articles.build(params[:article])
    @article.content = Content.new(params[:content])
    @article.content.user = current_user
    @article.content.article = @article

    return render(:action => :new) unless @article.content.save && @article.save

    embed_video(@article.id) and return if params[:embed_video] 

    flash[:notice] = "Successfully created"
    redirect_to library_url, :category => @category
  end

  def destroy
    @article = current_community.articles.find(params[:id])
    flash[:notice] = "Deleted the article named '#{@article}'"
    @article.destroy
    redirect_to library_url
  end
  
  def upload
    @video = Attachment.find(params[:id])
    @upload_form_url = %(http://#{Panda.api_domain}:#{Panda.api_port}/videos/#{@video.panda_id}/form)
  end
  
  def done
    @video = Attachment.find_by_panda_id(params[:id])
    get_current_community_from(@video)
  end
  
  def status
    @video = Video.find_by_panda_id(params[:id])
    @panda_video = Panda::Video.new_with_attrs(YAML.load(params[:video])[:video])
    @video.update_panda_status(@panda_video)
    get_current_community_from(@video)
    render :nothing => true
  end
  
  private
  
  def get_current_community_from(video)
    @article = @video.content.article
    @current_community = @article.community
  end
  
  def embed_video(article_id)
    @panda_video = Panda::Video.create
    @video = @article.content.attachments.build(:user => current_user, :embedded => true, :panda_id => @panda_video.id)
    unless @video.save_without_validation
      render :text => @video.inspect, :layout => false
    else
      flash[:notice] = "Ready to upload your video"
      redirect_to upload_article_url(:id => @video.id, :article_id => article_id)
    end
  end
  
  def get_access_controlled_object
    Article.find(params[:id]) if params[:id]
  end
end
