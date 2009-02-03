class Course < ActiveRecord::Base
  belongs_to :user
  belongs_to :community
  has_many :chapters, :order => :position, :dependent => :destroy
  has_many :lessons, :through => :chapters

  validates_presence_of :title, :description

  alias_attribute :to_s, :title

  is_indexed :fields => ['title', 'description', 'community_id', 'draft']

  def draft_to_users?
    return self.draft?
  end

  def visible_to(user)
    return !self.draft_to_users? || user == self.community.owner
  end

  #returns true if this is a draft
  def contains_drafts
    for chapter in chapters
      return true if chapter.draft || chapter.contains_drafts
    end
    return false
  end

  def contains_premium_visible_to(user)
    for chapter in chapters
      for lesson in chapter.lessons
        return true if !lesson.content.access_classes.empty? && lesson.visible_to(user)
      end
    end
    return false
  end

  def contains_registered_visible_to(user)
    for chapter in chapters
      for lesson in chapter.lessons
        return true if lesson.content.registered && lesson.visible_to(user)
      end
    end
    return false
  end
end