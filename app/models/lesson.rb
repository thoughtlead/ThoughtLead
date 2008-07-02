class Lesson < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :content
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  
  def to_s
    content.title
  end
  
  def draft_to_users?
    return self.content.draft? || self.chapter.draft_to_users?
  end
  
  def accessible_to(user)
    if self.draft_to_users? && user != self.chapter.course.community.owner
      return false
    end
    if user == self.chapter.course.community.owner
      return true
    end
    #Authenticated System uses :false when there is no current_user
    if (user == :false) && (self.content.premium? || self.content.registered?)
      return false
    end
    if self.content.premium?
      return user.active?
    end
    if self.content.registered? 
      return !user.nil?
    end
    return true    
  end
  
  def lesson_notes
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
