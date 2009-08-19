class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  belongs_to :theme
  has_many :responses, :dependent => :destroy
  has_many :email_subscriptions, :dependent => :destroy
  has_many :subscribers, :class_name => 'User', :through => :email_subscriptions

  named_scope :get_all, :include => [:theme, :responses]
  named_scope :uncategorized, :conditions => { :theme_id => nil }

  validates_presence_of :title, :body, :theme

  is_indexed :fields => ['title', 'body', 'community_id']

  alias_attribute :to_s, :title

  def uncategorized?
    theme.nil?
  end

  def is_registered?
    return false if theme.nil?
    return theme.is_registered?
  end

  def access_classes
    return theme.nil? ? nil : theme.access_classes
  end

  def is_visible_to(user)
    return true if theme.nil?
    return theme.is_visible_to(user)
  end
end
