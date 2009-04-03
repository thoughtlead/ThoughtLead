class MediaController < ApplicationController
  # Don't require an authenticity token for status post...
  skip_before_filter :verify_authenticity_token, :only => :status

  skip_before_filter :find_community, :only => [ :status, :done ]
  skip_before_filter :control_access, :only => [ :status, :done ]

  before_filter :owner_login_required, :only => :upload
  before_filter :community_is_active, :only => :upload
  
  def upload
    @video = Attachment.find(params[:id])
    @upload_form_url = %(http://#{Panda.api_domain}:#{Panda.api_port}/videos/#{@video.panda_id}/form)
  end
    
  def done
    @video = Attachment.find_by_panda_id(params[:id])
    get_current_community_from(@video)
    render :template => '/media/done', :layout => false
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
    content = @video.content
    # Is this an article?
    if content.article_content?
      @article = content.article
      @current_community = @article.community
      
    # Or is it a lesson?
    elsif content.lesson_content?
      @lesson = content.lesson
      @course = @lesson.chapter.course
      @current_community = @course.community
    
    # Uh oh, it's neither?
    else
      @current_community = nil
    end
    
    return @current_community
  end
end
