module ThemesHelper
  def get_access_description(theme)
    if !theme.access_classes.blank?
      return "(Accessible to #{theme.access_classes.map(&:name).join(", ")} Members)"
    elsif theme.is_registered?
      return "(Accessible to Registered Members)"
    else
      return "(Accessible to Everyone)"
    end
  end
end
