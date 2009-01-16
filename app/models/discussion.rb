class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  belongs_to :theme
  has_many :responses, :dependent => :destroy

  validates_presence_of :title, :body, :theme

  is_indexed :fields => ['title', 'body', 'community_id']

  alias_attribute :to_s, :title

  named_scope :for_theme, lambda { | theme_id |
    { :conditions => ({ :theme_id => (theme_id == 'nil' || theme_id == '') ? nil : theme_id } if theme_id) }
  }

  def is_premium?
    self.community.discussion_accessibility == 1
  end

  def is_registered?
    unless theme.nil?
      return theme.registered
    end
    false
  end

  def access_classes
    return theme.nil? ? nil : theme.access_classes
  end

  def is_visible_to(user)
    unless theme.nil?
      return theme.is_visible_to(user)
    end
    true
  end
end
