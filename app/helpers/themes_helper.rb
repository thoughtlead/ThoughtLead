module ThemesHelper
  def current_class_all_tasks
    return :current unless params[:theme]
  end
  
  def current_class_uncategorized
    return :current if params[:theme] && Theme.find_by_id(params[:theme]) == nil
  end
  
  def current_class_for_discussion_uncategorized(discussion)
    return :current if discussion.theme.nil?
  end
  
  def current_class_for_discussion_theme(discussion, theme)
    return :current if discussion.theme == theme
  end
  
  def current_class_for_theme(theme)
    return :current if Theme.find_by_id(params[:theme]) == theme
  end
  
end
