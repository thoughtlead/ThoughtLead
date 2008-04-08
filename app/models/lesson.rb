class Lesson < ActiveRecord::Base
  
  validates_presence_of :title, :body, :teaser

  belongs_to :chapter
  belongs_to :user
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  

  alias_attribute :to_s, :title
  
end
