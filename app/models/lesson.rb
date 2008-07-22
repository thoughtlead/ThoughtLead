class Lesson < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :content
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  
  def higher_item_visible_to(user)
    lesson = self.higher_item
    while lesson && !lesson.visible_to(user) do
      lesson = lesson.higher_item
    end
    return lesson
  end
  
  def lower_item_visible_to(user)
    lesson = self.lower_item
    while lesson && !lesson.visible_to(user) do
      lesson = lesson.lower_item
    end
    return lesson
  end
  
  def community
    chapter.community
  end
  
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
  
  def teaser_text
    self.content.teaser_text
  end
  
end
