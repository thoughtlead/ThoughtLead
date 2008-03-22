class Chapter < ActiveRecord::Base
  
  validates_presence_of :name
  has_many :lessons, :dependent => :destroy
  alias_attribute :to_s, :name
  
end
