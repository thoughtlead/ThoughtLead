class Community < ActiveRecord::Base
  has_many :articles
  has_many :users
  belongs_to :owner, :class_name => "User"
  
  validates_presence_of :subdomain
  validates_uniqueness_of :subdomain
  
end
