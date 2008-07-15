
class Community < ActiveRecord::Base
  
  has_many :users
  has_many :courses, :dependent => :destroy
  has_many :discussions, :dependent => :destroy
  has_many :themes, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :articles, :dependent => :destroy
  belongs_to :owner, :class_name => "User"
  
  validates_presence_of :host, :name
  validates_uniqueness_of :host
  validate :validate_host_restrictions
  
  before_create :owner_becomes_user

  alias_attribute :to_s, :name

  def authenticate(login, password)
    u = users.find_by_login(login) 
    u && !u.disabled? && u.authenticated?(password) ? u : nil
  end
  
  def refresh_from_spreedly
    subscriber = Spreedly::Community::Subscriber.find(self.id)
    self.active = subscriber.active
    self.spreedly_token = subscriber.token
    self.eligible_for_free_trial = subscriber.eligible_for_free_trial
    save
  end
  
  def discussions_are_premium?
    return self.discussion_accessibility > 0
  end
  
  private
    def owner_becomes_user
      self.users << self.owner unless self.users.include?(self.owner)
    end
  
    def validate_host_restrictions
      errors.add :host, "is reserved" if  /(db|app|server|test|staging|web|ftp|mail|files)[0-9]*$/.match(self.host.split(".").first)
      errors.add :host if /[^a-zA-Z0-9\-]+/.match(self.host.split(".").first)
    end
  
  
end

