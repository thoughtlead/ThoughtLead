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
    default_stylesheet = "/themes/default/default.css"
    return default_stylesheet unless current_community
    return default_stylesheet unless File.exist?(File.expand_path(File.dirname(__FILE__) + "/../../public/themes/#{current_community.subdomain}/#{current_community.subdomain}.css"))
    "/themes/#{current_community.subdomain}/#{current_community.subdomain}.css"
  end
  
  def community_logo
    default_logo = "/themes/default/images/logo.gif"
    return default_logo unless current_community
    return default_logo unless File.exist?(File.expand_path(File.dirname(__FILE__) + "/../../public/themes/#{current_community.subdomain}/images/logo.gif"))
    "/themes/#{current_community.subdomain}/images/logo.gif"
  end
  
end
