require 'digest/sha1'

class User < ActiveRecord::Base
  attr_accessor :password, :uploaded_avatar_data
  attr_writer   :password_required

  validates_presence_of     :login, :email
  validates_presence_of     :password, :password_confirmation, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  before_save :encrypt_password
  
  belongs_to  :community
  has_many    :courses
  has_one     :avatar

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
    display_name
  end
  
  def display_name
    return super unless super.blank?
    login
  end
  
  def make_reset_password_token
    self.update_attribute(:reset_password_token, Digest::SHA1.hexdigest(Time.now.to_s.split(//).concat(login.split(//)).sort_by { rand }.join))
  end 
  
  def owner?
    community.owner == self
  end
  
  def active
    return true if owner?
    super
  end
  
  def save_with_avatar 
    an_avatar = self.avatar || Avatar.new
    begin 
      self.transaction do 
        if uploaded_avatar_data && uploaded_avatar_data.size > 0 
          an_avatar.uploaded_data = uploaded_avatar_data 
          an_avatar.destroy_thumbnails 
          an_avatar.save! 
          self.avatar = an_avatar
        end 
        save!
      end 
    rescue Exception => e
      if an_avatar.errors.on(:size) 
        errors.add_to_base("Uploaded image is too large (5MB max).") 
        return false
      end 
      if an_avatar.errors.on(:content_type) 
        errors.add_to_base("Uploaded image content-type is not valid.") 
        return false
      end 
      raise e 
    end 
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
