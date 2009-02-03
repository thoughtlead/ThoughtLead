class LessonsController < ApplicationController
  before_filter :load_objects
  before_filter :owner_login_required, :except => [ :show ]
  before_filter :community_is_active

  uses_tiny_mce(tiny_mce_options)

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

    flash[:notice] = "Successfully created"
    redirect_to @lesson
  end

  def update
    @lesson.attributes = params[:lesson]
    @lesson.content.attributes = params[:content]

    return render(:action => :edit) unless @lesson.content.save && @lesson.save

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
