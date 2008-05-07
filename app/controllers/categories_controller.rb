class CategoriesController < ApplicationController
  
  before_filter :owner_login_required
  
  def index
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    @category.community = current_community
    
    return render(:action => :index) unless @category.save

    flash[:notice] = "Successfully created category"
    redirect_to categories_url
  end
  
  def update
    @category = current_community.categories.find(params[:id])
    
    return render(:action => :edit) unless @category.update_attributes(params[:category])
    
    flash[:notice] = "Successfully saved category"
    redirect_to categories_url
  end

  def edit
    @category = current_community.categories.find(params[:id])    
  end
  
  def destroy
    @category = current_community.categories.find(params[:id])
    
    @category.destroy
    flash[:notice] = "Successfully deleted the category named '#{@category}'"
    redirect_to categories_url
  end
  
end
