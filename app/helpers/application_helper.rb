module ApplicationHelper
  
    def display_lesson(lesson)
    !lesson.draft || current_user == lesson.chapter.course.community.owner
  end
  
  def lesson_notes(lesson)
    s = []
    if lesson.premium
      s << "Premium"
    end
    if lesson.registered
      s << "Registered"
    end
    if lesson.draft
      s << "Draft"
    end
    return s * "; "
  end
  
  def course_index_notes(course)
    s = []
    if course.draft
      s << "Draft"
    elsif course.contains_drafts && current_user == course.community.owner
      s << "Has Draft Content"
    end
    if course.contains_premium
      s << "Has Premium Content"
    end
    if course.contains_registered
      s << "Has Registered Content"
    end
    return s * "; "
  end
  
  def link_to_lesson(lesson)
    if(lesson.accessible_to(current_user))
      return link_to(h(lesson), [lesson.chapter.course, lesson.chapter, lesson])
    else
      return h(lesson)
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
  
  def link_to_lesson(lesson, link_text=lesson.title)
    link_to link_text, course_chapter_lesson_path(lesson.chapter.course, lesson.chapter, lesson)
  end
  
  private
    def themed_file(path, default_path = path) 
      default_file = "/themes/default/#{default_path}"
      return default_file unless current_community
      return default_file unless File.exist?(File.expand_path(File.dirname(__FILE__) + "/../../public/themes/#{current_community.subdomain}/#{path}"))
      "/themes/#{current_community.subdomain}/#{path}"
    end
    
end
