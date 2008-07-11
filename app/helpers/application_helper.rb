module ApplicationHelper
  
  def course_index_notes(course)
    s = []
    if course.draft
      s << "Draft"
    elsif course.contains_drafts && logged_in_as_owner?
      s << "Has Draft Content"
    end
    if course.contains_premium_visible_to(current_user)
      s << "Has Premium Content"
    end
    if course.contains_registered_visible_to(current_user)
      s << "Has Registered Content"
    end
    return s * "; "
  end
  
  def access_controlled_link(ac_object,text=h(ac_object))
    if ac_object.is_premium? && !logged_in_as_active?
      if logged_in?
        link_to text, intermediate_url(:redirect_to => upgrade_url, :notice => "You need to upgrade your account to view that content.")
      else
        session[:return_to] = upgrade_url
        link_to text, intermediate_url(:redirect_to => login_url, :notice => "You must login to a premium account or create a new premium account to view that content.<br/>" + 
          "To create a new premium acount you must first register or login as a free member.<br/>" +
          "Once you are logged in simply click the \"Upgrade Membership\" link and you'll be able to access premium content in no time.")
      end
    elsif ac_object.is_registered? && !logged_in?
      link_to text, intermediate_url(:redirect_to => login_url, :notice => "You must login or create an account to view that content.")
    else
      if ac_object.class == Lesson
        link_to text, [ac_object.chapter.course, ac_object.chapter, ac_object]
      else
        link_to text, ac_object
      end
    end
  end
  
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
