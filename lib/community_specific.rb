class ActiveRecord::Base
  before_save :valid_community?
  
  class << self
    def current_community= (cc)
      @@current_community = cc
    end
    def current_community
      @@current_community if defined? @@current_community
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
    #TODO Should e-mail really be exluded from this?  Why is e-mail even an active record model? Does it ever get saved?
    return true if self.class == Community || self.class == Mailer || self.class == Email
    return self.class.current_community == self.community if defined? self.community unless self.class.current_community.nil?
    return false
  end
  
end