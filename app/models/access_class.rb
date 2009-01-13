class AccessClass < ActiveRecord::Base
  belongs_to :community

  def has_access_to(access_classes)
    access_classes.each do |access_class|
      return true if access_class == self
    end
    return false
  end
end