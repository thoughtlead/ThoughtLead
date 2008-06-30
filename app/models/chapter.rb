class Chapter < ActiveRecord::Base

  belongs_to :course
  validates_presence_of :name
  has_many :lessons, :order => :chapter_position, :dependent => :destroy
  alias_attribute :to_s, :name
  
  def contains_drafts
    for lesson in lessons
      return true if lesson.draft
    end
    return false
  end
  
end
