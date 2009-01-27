module SubscriptionHelper
  def get_access_description(access_class)
    if !access_class.children.blank?
      return "(Includes access to #{access_class.children.map(&:name).join(" and ")} content)"
    end
  end
end
