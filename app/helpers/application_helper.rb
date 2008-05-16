module ApplicationHelper
  
  def define_js_function(function_name, &block)
    parens = function_name.kind_of?(Symbol) ? "()" : ""
    update_page_tag do | page |
    	page << "function #{function_name}#{parens} {"
      yield page
    	page << "}"
    end	
  end
  
  def current_tag(tag_name, class_is_current_if, &block)
    content_tag(tag_name, { :class => (:current if class_is_current_if) }, &block)
  end
  
  def set_focus_to(id)
    javascript_tag("Field.focus('#{id}')");
  end
  
  def community_stylesheet
    themed_file(current_community ? "#{current_community.subdomain}.css" : nil, "default.css")
  end
  
  def community_logo
    themed_file("images/logo.gif")
  end
  
  private
    def themed_file(path, default_path = path) 
      default_file = "/themes/default/#{default_path}"
      return default_file unless current_community
      return default_file unless File.exist?(File.expand_path(File.dirname(__FILE__) + "/../../public/themes/#{current_community.subdomain}/#{path}"))
      "/themes/#{current_community.subdomain}/#{path}"
    end
  
  
end
