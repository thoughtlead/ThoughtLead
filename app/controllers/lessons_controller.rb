class LessonsController < ApplicationController
  before_filter :load_objects
  before_filter :owner_login_required, :except => [ :show ]
  before_filter :community_is_active
  before_filter :set_subsection_title

  uses_tiny_mce(tiny_mce_options)

  def sort
    params[dom_id(@chapter)].each_with_index do |id, index|
      Lesson.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

  def new
    @lesson = Lesson.new
    @lesson.content = Content.new
  end

  def create
    @lesson = @chapter.lessons.build(params[:lesson])
    @lesson.content = Content.new(params[:content])
    @lesson.content.user = current_user
    @lesson.content.lesson = @lesson

    return render(:action => :new) unless @lesson.content.save && @lesson.save

    embed_video and return if params[:embed_video] 

    flash[:notice] = "Successfully created"
    redirect_to @lesson
  end

  def update
    @lesson.attributes = params[:lesson]
    @lesson.content.attributes = params[:content]

    return render(:action => :edit) unless @lesson.content.save && @lesson.save

    embed_video and return if params[:embed_video] 

    flash[:notice] = "Successfully saved"
    redirect_to @lesson
  end

  def edit
  end

  def show
    owner_login_required if @lesson.draft_to_users? #is there a better home for me?
  end

  def destroy
    flash[:notice] = "Deleted the lesson named '#{@lesson}'"
    @lesson.destroy
    redirect_to @course
  end

  private
  
  def set_subsection_title
    if @lesson and @course
      set_headline :subsection => @lesson 
    end
  end
  
  def embed_video
    @panda_video = Panda::Video.create
    @video = @lesson.content.attachments.build(:user => current_user, :embedded => true, :panda_id => @panda_video.id)
    unless @video.save_without_validation
      render :text => @video.inspect, :layout => false
    else
      flash[:notice] = "Ready to upload your video"
      redirect_to media_upload_url(:id => @video.id)
    end
  end

  def get_access_controlled_object
    @lesson = current_community.lessons.find(params[:id]) if params[:id]
  end

  def load_objects
    if params[:id]
      @lesson = current_community.lessons.find(params[:id])
      @chapter = @lesson.chapter
    else
      @chapter = current_community.chapters.find(params[:chapter_id])
    end
    @course = @chapter.course
  end
end
