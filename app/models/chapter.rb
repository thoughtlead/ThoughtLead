class Chapter < ActiveRecord::Base
  belongs_to :course
  has_many :lessons, :order => :position, :dependent => :destroy

  acts_as_list :scope => :course

  validates_presence_of :name

  alias_attribute :to_s, :name

  def community
    course.community
  end

  def draft_to_users?
    return self.draft? || self.course.draft_to_users?
  end

  #returns true if this is a draft
  def contains_drafts
    for lesson in lessons
      return true if lesson.draft_to_users?
    end
    return false
  end
end
