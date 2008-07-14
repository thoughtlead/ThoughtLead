class Response < ActiveRecord::Base
  
  validates_presence_of :body
  belongs_to :discussion
  belongs_to :user
  
  is_indexed :fields => ['body'], :include => [{:association_name => 'discussion', :field => 'community_id'}]
  
  def is_premium?
    return discussion.is_premium?
  end
  
  def is_registered?
    return discussion.is_registered?
  end
  
end
