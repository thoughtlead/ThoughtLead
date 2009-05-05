module UsersHelper
  def details_format(details)
    stripped = h(details)
    linked = auto_link(stripped)
    simple_format(linked)
  end

  def get_membership_level_description(user)
    return "Community Owner" if user.owner?
    return 'Registered Member' if user.access_classes.empty?
    if user.access_classes.size > 1
      "Special Access"
    else
      "#{user.access_classes.first.name} Member"
    end
  end
end
