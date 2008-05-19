class Lesson < ActiveRecord::Base
  
  attr_accessor :uploaded_attachment_data
  validates_presence_of :title, :body, :teaser

  belongs_to :chapter
  belongs_to :user
  has_one :attachment, :dependent => :destroy
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  alias_attribute :to_s, :title
  
  
  def lesson_attachment=(it)  
    the_attachment = self.attachment || Attachment.new
    the_attachment.uploaded_data = it
    self.attachment = the_attachment unless it.to_s.blank?  
  end
    
end
