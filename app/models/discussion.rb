class Discussion < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  belongs_to :theme, :counter_cache => true
  has_many :responses, :dependent => :destroy
  has_many :email_subscriptions, :dependent => :destroy
  has_many :subscribers, :class_name => 'User', :through => :email_subscriptions

  named_scope :get_all, :include => [:theme, :responses]
  named_scope :by_age, :include => [:theme, :responses], :order => 'thread_last_updated_at DESC'
  named_scope :uncategorized, :conditions => { :theme_id => nil }
  
  named_scope :publicly_available, :conditions => {:registered => false}
  
  named_scope :accessible_to, lambda { |user| 
    if !user
      conditions = {"themes.registered" => false}
    elsif user == user.community.owner
      # do nothing
    else
      if user.access_class_ids.empty?
        ac = []
      else
        ac = user.access_class_ids
      end
      
      conditions = [
        '(SELECT count(id) FROM theme_access_classes where theme_id = themes.id) = 0 OR
          ( theme_access_classes.theme_id = themes.id AND
            theme_access_classes.access_class_id IN (?))', ac
      ]
    end
    { :include => [{:theme => :theme_access_classes }, :responses],
    :conditions => conditions }
  }

  validates_presence_of :title, :body, :theme
  
  before_create :set_thread_timestamp

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
  
  protected 
  
  def set_thread_timestamp
    self.thread_last_updated_at = Time.now
  end
end
