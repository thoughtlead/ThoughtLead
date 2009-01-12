class Theme < ActiveRecord::Base
  belongs_to :community
  has_many :discussions, :dependent => :nullify
  has_many :theme_access_classes, :dependent => :destroy
  has_many :access_classes, :through => :theme_access_classes

  validates_presence_of :name, :description

  alias_attribute :to_s, :name
end