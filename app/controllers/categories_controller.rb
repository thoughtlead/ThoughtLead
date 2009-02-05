class CategoriesController < ApplicationController
  before_filter :load_objects
  before_filter :owner_login_required

  def sort
    params[:categories].each_with_index do |id, index|
      Category.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

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
    return render(:action => :edit) unless @category.update_attributes(params[:category])

    flash[:notice] = "Successfully saved theme"
    redirect_to categories_url
  end

  def edit
  end

  def destroy
    @category.destroy
    flash[:notice] = "Successfully deleted the category named '#{@category}'"
    redirect_to categories_url
  end

  private

  def load_objects
    if params[:id]
      @category = current_community.categories.find(params[:id])
    end
  end
end
