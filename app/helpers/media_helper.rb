module MediaHelper
  # Generates a link to the appropriate article or lesson for the upload completed page
  def link_to_container(media=@video, community=@current_community)
    if media.content.article_content?
      link_to("View your article", article_url(media.content.article, :host => community.host), :target => "_top")
    elsif media.content.lesson_content?
      link_to("View your lesson", lesson_url(media.content.lesson, :host => community.host), :target => "_top")
    else
      ''
    end
  end
end
