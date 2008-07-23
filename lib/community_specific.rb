class ActiveRecord::Base
  before_validation :valid_community?
  
  class << self
    def current_community= (cc)
      return if defined? @@always_valid && @@always_valid
      @@current_community = cc
    end
    def current_community
      @@current_community if defined? @@current_community
    end
    def current_community_always_valid(bool)
      @@always_valid = bool
      @@current_community = (bool ? :valid : nil)
    end
  end
  
  def after_find
    valid = valid_community?
    unless valid
      self.id = nil 
      self.attributes.keys.each do |key|
        self.attributes = {key => nil}
      end
    end
    return valid
  end
  
  private
  
  def valid_community?
    return true if self.class.current_community == :valid
    #TODO Should e-mail really be exluded from this?  Why is e-mail even an active record model? Does it ever get saved?
    return true if self.class == Community || self.class == Mailer || self.class == Email
    return self.class.current_community == self.community if defined? self.community unless self.class.current_community.nil?
    return false
  end
  
end