class Lesson < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :content
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  
  def to_s
   (content && content.title) || ""
  end
  
  def draft_to_users?
    return self.content.draft? || self.chapter.draft_to_users?
  end
  
  def is_premium?
    self.content.premium?
  end
  
  def is_registered?
    self.content.registered?
  end
  
  def visible_to(user)
    !self.draft_to_users? || user == self.chapter.course.community.owner
  end
  
  def notes
    s = []
    if self.content.premium
      s << "Premium"
    end
    if self.content.registered
      s << "Registered"
    end
    if self.content.draft
      s << "Draft"
    end
    return s * "; "
  end
  
  
end
