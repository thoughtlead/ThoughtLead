class Theme < ActiveRecord::Base
  belongs_to :community
  has_many :discussions, :dependent => :nullify
  has_many :theme_access_classes, :dependent => :destroy
  has_many :access_classes, :through => :theme_access_classes

  validates_presence_of :name, :description

  alias_attribute :to_s, :name

  def is_visible_to(user)
    return true if user == community.owner
    unless access_classes.blank?
      return user.has_access_to(self) unless user.nil?
    end
    if registered
        return !user.nil?
    else #content is publicly viewable
        return true
    end
    false
  end
end
