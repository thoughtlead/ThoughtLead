module UsersHelper

  def details_format(details)
    stripped = h(details)
    linked = auto_link(stripped)
    simple_format(linked)
  end

  def get_membership_level_description(user)
    return "Community Owner" if user.owner?
    user.access_class.nil? ? 'Registered Member' : "#{user.access_class.name} Member"
  end
end
