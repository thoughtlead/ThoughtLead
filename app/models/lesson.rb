class Lesson < ActiveRecord::Base
  
  validates_presence_of :title, :body

  belongs_to :chapter
  belongs_to :user

  alias_attribute :to_s, :title
  
end
