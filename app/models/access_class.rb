class AccessClass < ActiveRecord::Base
  belongs_to :community

  def is_accessible_to(other_access_class)
    return self == other_access_class
  end

  def has_access_to(access_classes)
    access_classes.each do |access_class|
      return true if access_class.is_accessible_to(self)
    end
    return false
  end
end