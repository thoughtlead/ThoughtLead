class AccessClass < ActiveRecord::Base
  belongs_to :community
  acts_as_list :scope => :community

  has_many :subscription_plans
  has_many :access_class_relationships
  has_many :children, :class_name => 'AccessClass', :through => :access_class_relationships

  validates_uniqueness_of :name, :case_sensitive => false, :scope => :community_id

  def has_access_to(access_class_or_classes)
    access_classes = if access_class_or_classes.is_a?(Enumerable)
      access_class_or_classes
    else
      [access_class_or_classes].compact
    end

    return true if access_classes.empty?
    access_classes.each do |access_class|
      return true if access_class == self || children.include?(access_class)
    end
    return false
  end
end
