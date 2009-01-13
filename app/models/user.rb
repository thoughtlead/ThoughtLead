require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to  :community
  has_many    :courses
  has_one     :avatar, :dependent => :destroy
  belongs_to  :access_class

  attr_accessor :password, :uploaded_avatar_data
  attr_writer   :password_required

  validates_presence_of     :login, :email, :first_name, :last_name
  validates_presence_of     :password, :password_confirmation, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_uniqueness_of   :login, :email, :case_sensitive => false, :scope => :community_id
  validates_uniqueness_of   :display_name, :case_sensitive => false, :scope => :community_id, :allow_nil => true, :allow_blank => false

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

  def make_reset_password_token
    self.update_attribute(:reset_password_token, Digest::SHA1.hexdigest(Time.now.to_s.split(//).concat(login.split(//)).sort_by { rand }.join))
  end

  def owner?
    community.owner == self
  end

  alias :real_access_class :access_class
  def access_class
    owner? ? community.highest_access_class : real_access_class
  end

  def access_class=(ac)
    access_class = ac
  end

  def access_classes
    [access_class]
  end

  def user_avatar=(it)
    the_avatar = self.avatar || Avatar.new
    the_avatar.user = self
    the_avatar.uploaded_data = it
    self.avatar = the_avatar unless it.to_s.blank?
  end

  def refresh_from_spreedly
    Spreedly::User::Subscriber.configure(self.community)
    subscriber = Spreedly::User::Subscriber.find(self.id)
    self.active = subscriber.active
    self.spreedly_token = subscriber.token
    save
  end

  def has_access_to(object)
    return access_class.has_access_to(object.access_classes) if !access_class.nil?
    #else we know user is only registered
    return object.access_classes.blank?
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