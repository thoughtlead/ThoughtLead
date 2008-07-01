class ThemesController < ApplicationController
  
  before_filter :owner_login_required
  
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
    @theme = current_community.themes.find(params[:id])
    
    return render(:action => :edit) unless @theme.update_attributes(params[:theme])
    
    flash[:notice] = "Successfully saved theme"
    redirect_to themes_url
  end

  def edit
    @theme = current_community.themes.find(params[:id])    
  end
  
  def destroy
    @theme = current_community.themes.find(params[:id])
    
    @theme.destroy
    flash[:notice] = "Successfully deleted the theme named '#{@theme}'"
    redirect_to themes_url
  end
  
end
