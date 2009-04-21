require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :community
  has_many :courses
  has_one :avatar, :dependent => :destroy
  belongs_to :access_class
  has_one :subscription
  has_many :subscription_payments

  attr_accessor :password, :uploaded_avatar_data
  attr_writer   :password_required

  validates_presence_of     :login, :email, :first_name, :last_name
  validates_presence_of     :password, :password_confirmation, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_uniqueness_of   :login, :email, :case_sensitive => false, :scope => :community_id
  validates_uniqueness_of   :display_name, :case_sensitive => false, :scope => :community_id, :allow_nil => true, :allow_blank => false
  validates_associated :avatar

  before_save :encrypt_password

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
    login.gsub('.','-')
  end

  def make_reset_password_token
    self.update_attribute(:reset_password_token, Digest::SHA1.hexdigest(Time.now.to_s.split(//).concat(login.split(//)).sort_by { rand }.join))
  end

  def owner?
    community.owner == self
  end

  alias :real_access_class :access_class
  def access_class
    # if the user is the community owner then they have access to everything
    owner? ? Class.new { def has_access_to(*args) true end }.new : real_access_class
  end

  def access_classes
    [access_class].compact
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
    return access_class.has_access_to(object.access_classes) if !access_class.nil?
    #else we know user is only registered
    return object.access_classes.blank?
  end

  def self.find_all_by_community_and_send_email_notifications(community, send_email_notifications = true)
    all(:conditions => {"community_id" => community.id, "send_email_notifications" => send_email_notifications})
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
end
