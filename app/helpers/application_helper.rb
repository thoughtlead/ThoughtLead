module ApplicationHelper  
  def headline
    site_head = [@headline[:site]].compact.join(" | ")
    content_head = [@headline[:content], @headline[:subsection], @headline[:section]]
    
    total_length = site_head.length + content_head.compact.join(" | ").length
    if total_length > 63
      remaining = 63 - (site_head.length + 3)      
      max = remaining / content_head.compact.size
      chead = content_head.compact.collect do |ch|
        if ch.to_s.length > max
          "#{ch.to_s[0..max]}..."
        else
          ch
        end
      end
    else
      chead = content_head
    end
    pieces = chead << site_head
    pieces.compact.join(" | ")
  end
  
  def avatar_link_for(user, size = :medium)
    link_to(avatar_for(user, size), user)
  end

  def avatar_for(user, size = :medium)
    image_tag(avatar_filename(user, size), :id => "profile_avatar")
  end

  def avatar_filename(user, size = :medium)
    if user.avatar
      user.avatar.public_filename(size)
    else
      "default_avatar_#{size}.png"
    end
  end

  def flash_class
    return "" if flash.values.empty?
    %{class = "#{flash.keys.join(' ')}"}
  end

  def flash_value
    flash.values.collect { | value | "<p>#{value}</p>"}.join("\n")
  end

  def body_tag
    onload_str = @onload_event ? %{ onload="#{@onload_event}"} : ''
    "<body#{onload_str}>"
  end

  def teaser_format(teaser)
    auto_link(h(teaser))
  end

  def course_index_notes(course)
    s = []
    if course.draft
      s << '<li class="draft">Draft</li>'
    elsif course.contains_drafts && logged_in_as_owner?
      s << '<li class="draft has_content">Draft Content</li>'
    end
    if course.contains_premium_visible_to(current_user)
      s << '<li class="premium has_content"><span class="icon">Premium</span> <span class="content">Content</span></li>'
    end
    if logged_in_as_owner? && course.contains_registered_visible_to(current_user)
      s << '<li class="registered has_content"><span class="icon">Registered</span> <span class="content">Content</span></li>'
    end
    s.last.gsub!(/\">/, ' last">') if s.last
    return s * "\n"
  end

  def content_notes(content)
    s = []
    if !content.access_classes.empty?
      text = content.access_classes.collect(&:name).join(', ')
      s << "<li class=\"premium\"><span class=\"icon\">#{text}</span></li>"
    end
    if logged_in_as_owner? && content.registered
      s << '<li class="registered"><span class="icon">Registered</span></li>'
    end
    if content.draft
      s << '<li class="draft">Draft</li>'
    end
    s.last.gsub!(/\">/, ' last">') if s.last
    return s * "\n"
  end

  def define_js_function(function_name, &block)
    parens = function_name.kind_of?(Symbol) ? "()" : ""
    update_page_tag do | page |
      page << "function #{function_name}#{parens} {"
      yield page
      page << "}"
    end
  end

  def themed_public_file(filename)
    themes_absolute_dir = File.expand_path(File.dirname(__FILE__) + "/../../public/themes")

    themes_public_dir = "/themes"
    default_public_file = "#{themes_public_dir}/default/#{filename}"

    return default_public_file unless current_community
    return default_public_file unless File.exist?("#{themes_absolute_dir}/#{current_community.host}/#{filename}")
    "#{themes_public_dir}/#{current_community.host}/#{filename}"
  end

  def current_tag(tag_name, class_is_current_if, &block)
    content_tag(tag_name, { :class => (:current if class_is_current_if) }, &block)
  end

  def set_focus_to(id)
    javascript_tag("Field.focus('#{id}')");
  end

  def community_stylesheet
    themed_file(current_community ? "#{current_community.host}.css" : nil, "default.css")
  end

  def community_logo
    themed_file("images/logo.gif")
  end

  def create_discussion_link
    if current_user_can_post?
      content_tag :div, :class => :action, :id => :create_discussion do
        span = content_tag :span, '&nbsp;', :class => :button_left
        link = link_to new_discussion_path, :class => :button do
          plus = content_tag :span, "+", :class => "icon create"
          text = content_tag :span, "Create a Discussion", :class => "text"
          "#{plus}#{text}"
        end
        "#{span}#{link}"
      end
    end
  end
  
  def trackable?
    if Rails.env.production?
      if current_community && current_community.attribute_present?(:ga_property_id)
        GStats.analytics_account = current_community.ga_property_id
        GStats.domain = current_community.host
      end
    end
  end
  
  private

  def themed_file(path, default_path = path)
    default_file = "/themes/default/#{default_path}"
    return default_file unless current_community
    return default_file unless File.exist?(File.expand_path(File.dirname(__FILE__) + "/../../public/themes/#{current_community.host}/#{path}"))
    "/themes/#{current_community.host}/#{path}"
  end

  def snippet(thought, letters = 15)
    truncate(thought, :length => letters)
  end
end
