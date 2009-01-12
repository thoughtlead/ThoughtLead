class Lesson < ActiveRecord::Base
  belongs_to :chapter
  belongs_to :content, :dependent => :destroy

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
    return content.draft? || chapter.draft_to_users?
  end

  def is_premium?
    content.premium?
  end

  def is_registered?
    content.registered?
  end

  def visible_to(user)
    !self.draft_to_users? || user == chapter.course.community.owner
  end

  def teaser_text
    content.teaser_text
  end

  def access_classes
    content.access_classes
  end
end
