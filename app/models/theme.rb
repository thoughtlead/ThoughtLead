class Theme < ActiveRecord::Base
  belongs_to :community
  has_many :discussions, :dependent => :nullify
  has_many :theme_access_classes, :dependent => :destroy
  has_many :access_classes, :through => :theme_access_classes

  validates_presence_of :name, :description

  alias_attribute :to_s, :name

  def is_visible_to(user)
    return true if user == community.owner

    if access_classes.blank?
      if registered
        return !user.nil?
      else
        return true
      end
    else
      return false if user.nil?
      return user.has_access_to(self)
    end
  end
end
