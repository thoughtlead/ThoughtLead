
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

  def refresh_from_spreedly
    subscriber = SpreedlyCommunity::Subscriber.find(self.id)
    self.active = subscriber.active
    self.spreedly_token = subscriber.token
    self.eligible_for_free_trial = subscriber.eligible_for_free_trial
    save
  end
  
  
  private
    def owner_becomes_user
      self.users << self.owner unless self.users.include?(self.owner)
    end
  
    def validate_subdomain_restrictions
      errors.add :subdomain, "is reserved" if  /(www|db|app|server|test|staging|web|ftp|mail)[0-9]*$/.match(self.subdomain)
      errors.add :subdomain if /[^a-zA-Z0-9\-]+/.match(self.subdomain)
    end
  
  
end

module SpreedlyCommunity
  class Subscriber < ActiveResource::Base 
    if RAILS_ENV == "production"
      self.site = "https://43f5af47198f31ab66334b027b989f997e039865:X@spreedly.com/api2/test" 
    else
      self.site = "https://43f5af47198f31ab66334b027b989f997e039865:X@spreedly.com/api2/test" 
    end
  end
end
