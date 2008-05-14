module CategoriesHelper
  def current_class_all_tasks
    return :current unless params[:category]
  end
  
  def current_class_uncategorized
    return :current if params[:category] == 'nil'
  end
  
  def current_class_for_category(category)
    return :current if category == @category
  end
  
end
