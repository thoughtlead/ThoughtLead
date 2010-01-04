class Response < ActiveRecord::Base
  belongs_to :discussion, :counter_cache => true
  belongs_to :user

  validates_presence_of :body

  is_indexed :fields => ['body'], :include => [{:association_name => 'discussion', :field => 'community_id'}]
  
  after_save :update_thread_timestamp

  def community
    discussion.community if discussion
  end

  def is_registered?
    return discussion.is_registered?
  end

  def is_visible_to(user)
    return discussion.is_visible_to(user)
  end
  
  def editable_by?(user)
    return false unless user == self.user
    return true if created_at >= 15.minutes.ago.utc
    return true if updated_at and updated_at >= 15.minutes.ago.utc
    false
  end
  
  protected
  
  def update_thread_timestamp
    discussion.update_attribute(:thread_last_updated_at, created_at)
  end
end
