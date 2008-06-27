class Course < ActiveRecord::Base
  validates_presence_of :title, :description

  belongs_to :user
  belongs_to :community
  has_many :chapters, :dependent => :destroy

  alias_attribute :to_s, :title
  
  is_indexed :fields => ['title', 'description', 'community_id', 'draft']
  
  def contains_drafts
    for chapter in chapters
      return true if chapter.draft || chapter.contains_drafts
    end
    return false
  end
  
end
