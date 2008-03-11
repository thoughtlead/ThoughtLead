class Lesson < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :title, :body
  
end
