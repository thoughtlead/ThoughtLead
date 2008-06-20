class Lesson < ActiveRecord::Base
  
  attr_accessor :uploaded_attachment_data
  validates_presence_of :title, :body, :teaser

  belongs_to :chapter
  belongs_to :user
  has_one :attachment, :dependent => :destroy
  has_one :flash_video, :dependent => :destroy
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  alias_attribute :to_s, :title
  
  def lesson_attachment=(it)  
    the_attachment = self.attachment || Attachment.new
    the_attachment.uploaded_data = it
    self.attachment = the_attachment unless it.to_s.blank?  
  end
    
  def lesson_flash_video=(it)  
    the_flash_video = self.flash_video || FlashVideo.new
    the_flash_video.uploaded_data = it
    self.flash_video = the_flash_video unless it.to_s.blank?  
  end
  
end
