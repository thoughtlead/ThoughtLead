require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :community
  has_many :courses
  has_one :avatar, :dependent => :destroy
  belongs_to :access_class
  has_many :user_classes
  has_many :access_classes, :through => :user_classes
  
  # Subscriptions
  has_one :subscription
  has_many :subscription_payments

  # Affiliate tracking
  has_many :clicks, :class_name => 'AffiliateAction', :foreign_key => :referrer_id, :conditions => "action = 'click'"
  has_many :uniques, :class_name => 'AffiliateAction', :foreign_key => :referrer_id, :conditions => "action = 'unique'"
  has_many :signups, :class_name => 'AffiliateAction', :foreign_key => :referrer_id, :conditions => "action = 'signup'"
  has_many :upgrades, :class_name => 'AffiliateAction', :foreign_key => :referrer_id, :conditions => "action = 'upgrade'"
  
  has_many :referrals, :class_name => 'AffiliateAction', :foreign_key => :referrer_id
  has_many :referred_users, :through => :referrals, :conditions => "action = 'signup' AND referred_id IS NOT NULL", :source => :referred
  
  attr_accessor :password, :uploaded_avatar_data
  attr_writer   :password_required

  validates_presence_of     :login, :email, :first_name, :last_name, :affiliate_code
  validates_presence_of     :password, :password_confirmation, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_uniqueness_of   :login, :email, :case_sensitive => false, :scope => :community_id
  validates_uniqueness_of   :display_name, :case_sensitive => false, :scope => :community_id, :allow_nil => true, :allow_blank => false
  validates_uniqueness_of   :affiliate_code
  validates_associated :avatar

  before_save :encrypt_password
  after_create :add_user_class
  is_indexed :fields => ['login','about', 'interests', 'display_name', 'location', 'zipcode', 'community_id']

  def is_registered?
    return true
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  def remember_me
    self.remember_token_expires_at = Time.mktime(2035)
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def to_s
    display_name.blank? ? login : display_name
  end
  
  def to_param
    if login == email
      id.to_s
    else
      login.gsub('.','-')
    end
  end

  def make_reset_password_token
    self.update_attribute(:reset_password_token, Digest::SHA1.hexdigest(Time.now.to_s.split(//).concat(login.split(//)).sort_by { rand }.join))
  end

  def owner?
    return false if community.nil?
    community.owner == self
  end

  alias :real_access_classes :access_classes
  def access_classes
    # if the user is the community owner then they have access to everything
    owner? ? [Class.new { def has_access_to(*args) true end; def has_exclusive_access_to(*args) true end;  }.new] : real_access_classes
  end

  def can_post
    community.themes.each do |theme|
      return true if has_access_to(theme)
    end
    return false
  end

  def user_avatar=(it)
    the_avatar = self.avatar || Avatar.new
    the_avatar.user = self
    the_avatar.uploaded_data = it
    self.avatar = the_avatar unless it.to_s.blank?
  end

  def has_access_to(object)
    # Test user access classes first
    unless access_classes.empty?
      if access_classes.size == 1
        return access_classes.first.has_access_to(object.access_classes)
      else
        return access_classes.any? { |ac| ac.has_exclusive_access_to(object.access_classes) } 
      end
    end
    # else we know user is only registered
    # And return true only if the object has no required classes
    return object.access_classes.blank?
  end
  
  def self.find_by_login_or_email(token = nil)
    return nil if token.nil?
    
    # Check for numeric first, and try a find by ID, returning if a user exists
    begin
      if token.to_i.to_s == token.to_s and user = User.find(token)
        return user
      end
    rescue ActiveRecord::RecordNotFound
    end
    
    # Otherwise, check the token against login and return user if exists
    if user = User.find_by_login(token)
       return user

    # Then check the token against enail and return user if exists
    elsif user = User.find_by_email(token)
       return user

    # No user found
    else
      return nil
    end
  end

  def self.find_all_by_community_and_send_email_notifications(community, send_email_notifications = true)
    all(:conditions => {"community_id" => community.id, "send_email_notifications" => send_email_notifications})
  end
  
  def set_affiliate_code!
    update_attribute(:affiliate_code, User.generate_affiliate_code)
  end
  
  protected

  def before_validate_on_create
    self.affiliate_code = User.generate_affiliate_code if self.new_record? and self.affiliate_code.blank?
  end
  
  def self.generate_affiliate_code
    ac = rand(36**8).to_s(36) 
    while self.exists?(['affiliate_code = ?', ac])
      ac = rand(36**8).to_s(36)
    end
    return ac
  end

  private

  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    @password_required || crypted_password.blank? || !@password.blank? || !@password_confirmation.blank?
  end
  
  def add_user_class
    unless access_class_id.nil?
      user_classes.find_or_create_by_access_class_id(access_class_id)
    end 
  end
end
