module AccessClassesHelper
  def get_access_description(access_class)
    if !access_class.children.blank?
      return "(Includes access to #{access_class.children.map(&:name).join(" and ")} content)"
    end
  end
  
  def toggle_access_class_link(access_class)
    aktion = access_class.activated? ? "Disable" : "Enable"
    style = access_class.activated? ? "" : "color:red"
    link_to aktion, toggle_access_class_url(access_class), :method => :post, :style => style
  end
end
