class Discussion < ActiveRecord::Base
  
  validates_presence_of :title, :body
  belongs_to :user
  belongs_to :community
  belongs_to :theme
  has_many :responses, :dependent => :destroy
  
  is_indexed :fields => ['title', 'body', 'community_id'] 
  
  alias_attribute :to_s, :title
  
  named_scope :for_theme, lambda { | theme_id | 
    { :conditions => ({ :theme_id => (theme_id == 'nil' || theme_id == '') ? nil : theme_id } if theme_id) } 
  }
  
  def accessible_to(user)
    if self.community.discussion_accessibility > 0
      #authenticated system uses :false for non-users
      return false if user == :false
      return user.active?
    end
    return true
  end
  
end
