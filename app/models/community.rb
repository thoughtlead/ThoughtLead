class Community < ActiveRecord::Base
  has_many :articles
  has_many :users
  has_many :courses
  belongs_to :owner, :class_name => "User"
  
  validates_presence_of :subdomain, :name
  validates_uniqueness_of :subdomain
  
  before_create :owner_becomes_user

  alias_attribute :to_s, :name

  private
    def owner_becomes_user
      self.users << self.owner
    end
  
  
  
end
