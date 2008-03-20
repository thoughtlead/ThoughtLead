class Community < ActiveRecord::Base
  has_many :articles
  has_many :users
  has_many :courses
  belongs_to :owner, :class_name => "User"
  
  validates_presence_of :subdomain, :name
  validates_uniqueness_of :subdomain
  
  alias_attribute :to_s, :name
  
  
end
