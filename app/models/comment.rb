class Comment < ActiveRecord::Base
  
  validates_presence_of :body
  belongs_to :discussion
  belongs_to :user
  
end
