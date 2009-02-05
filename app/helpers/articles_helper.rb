module ArticlesHelper
  def current_class_general
    return :current if params[:category] && Category.find_by_id(params[:category]) == nil
  end

  def current_class_all_categories
    return :current unless params[:category]
  end

  def current_class_for_category(category)
    return :current if Category.find_by_id(params[:category]) == category
  end
end
