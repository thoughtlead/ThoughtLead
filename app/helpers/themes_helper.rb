module ThemesHelper
  def current_class_all_tasks
    return :current unless params[:theme]
  end
  
  def current_class_uncategorized
    return :current if params[:theme] == 'nil'
  end
  
  def current_class_for_theme(theme)
    return :current if theme == @theme
  end
  
end
