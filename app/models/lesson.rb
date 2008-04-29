class Lesson < ActiveRecord::Base
  
  attr_accessor :uploaded_attachment_data
  validates_presence_of :title, :body, :teaser

  belongs_to :chapter
  belongs_to :user
  has_one :attachment
  
  acts_as_list :scope => :chapter, :column => :chapter_position
  alias_attribute :to_s, :title
  
  
  def save_with_attachment 
    return false unless valid? 
    an_attachment = self.attachment || Attachment.new
    begin 
      self.transaction do 
        if uploaded_attachment_data && uploaded_attachment_data.size > 0 
          an_attachment.uploaded_data = uploaded_attachment_data 
          an_attachment.save! 
          self.attachment = an_attachment
        end 
        save!
      end 
    rescue Exception => e
      if an_attachment.errors.on(:size) 
        errors.add_to_base("Uploaded file is too large (25MB max).") 
        return false
      end 
      raise e 
    end 
  end 
  
end
