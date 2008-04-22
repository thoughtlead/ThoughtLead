module UsersHelper
  
  def details_format(details)
    stripped = h(details)
    linked = auto_link(stripped)
    simple_format(linked)
  end
  
end
