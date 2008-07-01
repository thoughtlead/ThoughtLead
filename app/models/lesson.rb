class Lesson < ActiveRecord::Base
  
  attr_accessor :uploaded_attachment_data
  validates_presence_of :title, :body, :teaser
  
  belongs_to :chapter
  belongs_to :user
  has_many :attachments, :dependent => :destroy
  has_one :flash_video, :dependent => :destroy
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  alias_attribute :to_s, :title
  
  # Adding an association with the user's community so that we can filter on community
  is_indexed :fields => ['title', 'body', 'teaser', 'draft'], :include => [{:association_name => 'user', :field => 'community_id'}]
  
  def draft_to_users?
    return self.draft? || self.chapter.draft_to_users?
  end
  
  def accessible_to(user)
    if self.draft? && user != self.chapter.course.community.owner
      return false
    end
    if user == self.chapter.course.community.owner
      return true
    end
    #Authenticated System uses :false when there is no current_user
    if (user == :false) && (self.premium? || self.registered?)
      return false
    end
    if self.premium?
      return user.active?
    end
    if self.registered? 
      return !user.nil?
    end
    return true    
  end
  
  def access_level
    return "Premium" if self.premium
    return "Registered" if self.registered
    return "Public"
  end
  
  def access_level= (value)
    self.premium = (value == "Premium")
    self.registered = (value == "Registered")
  end
  
  def lesson_attachments=(it)
    for attachment in it
      if(!attachment.blank?)
        the_attachment = Attachment.new
        the_attachment.uploaded_data = attachment      
        self.attachments << the_attachment unless it.to_s.blank?  
      end
    end
  end
  
  def lesson_flash_video=(it)  
    the_flash_video = self.flash_video || FlashVideo.new
    the_flash_video.uploaded_data = it
    self.flash_video = the_flash_video unless it.to_s.blank?  
  end
  
end
