class Community < ActiveRecord::Base
  has_many :users
  has_many :courses, :dependent => :destroy
  has_many :discussions, :dependent => :destroy
  belongs_to :owner, :class_name => "User"
  
  validates_presence_of :subdomain, :name
  validates_uniqueness_of :subdomain
  validate :validate_subdomain_restrictions
  
  before_create :owner_becomes_user

  alias_attribute :to_s, :name

  private
    def owner_becomes_user
      self.users << self.owner unless self.users.include?(self.owner)
    end
  
    def validate_subdomain_restrictions
      errors.add :subdomain, "is reserved" if  /(www|db|app|server|test|staging|web|ftp|mail)[0-9]*$/.match(self.subdomain)
      errors.add :subdomain if /[^a-zA-Z0-9\-]+/.match(self.subdomain)
    end
  
  
end
