class ThemesController < ApplicationController
  before_filter :load_objects
  before_filter :owner_login_required

  def sort
    params[:themes].each_with_index do |id, index|
      Theme.update_all(['position=?', index+1], ['id=?', id])
    end
  end

  def index
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(params[:theme])
    @theme.community = current_community

    return render(:action => :index) unless @theme.save

    flash[:notice] = "Successfully created theme"
    redirect_to themes_url
  end

  def update
    return render(:action => :edit) unless @theme.update_attributes(params[:theme])

    flash[:notice] = "Successfully saved theme"
    redirect_to themes_url
  end

  def edit
  end

  def destroy
    @theme.destroy
    flash[:notice] = "Successfully deleted the theme named '#{@theme}'"
    redirect_to themes_url
  end

  private

  def load_objects
    if params[:id]
      @theme = current_community.themes.find(params[:id])
    end
  end
end
