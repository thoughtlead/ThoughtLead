class AccessClass < ActiveRecord::Base
  belongs_to :community

  def is_accessible_to_someone_with(other_access_class)
    return false if other_access_class.nil?
    return self.eql?(other_access_class)
  end

  def eql?(other)
    return self.id == other.id
  end
end