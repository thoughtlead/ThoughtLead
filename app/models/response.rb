class Response < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :user

  validates_presence_of :body

  is_indexed :fields => ['body'], :include => [{:association_name => 'discussion', :field => 'community_id'}]

  def community
    discussion.community if discussion
  end

  def is_registered?
    return discussion.is_registered?
  end

  def is_visible_to(user)
    return discussion.is_visible_to(user)
  end
end
