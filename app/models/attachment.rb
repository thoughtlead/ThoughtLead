class Attachment < ActiveRecord::Base
  belongs_to      :user
  belongs_to      :content
  has_attachment  :storage => :s3, :max_size => 100.megabytes, :s3_access => :authenticated_read, :content_type => [:image,"video/x-flv","audio/x-mp3"]
  validates_as_attachment
  
  def community
    content.community if content
  end
  
  def attachment_attributes_valid?
    set_type_for_embedded_media
    errors.add_to_base("Uploaded file #{filename} is too large (100MB max).") if attachment_options[:size] && !attachment_options[:size].include?(send(:size))
    errors.add_to_base("Uploaded file #{filename} has invalid content.") if embedded? && attachment_options[:content_type] && !attachment_options[:content_type].include?(send(:content_type))
  end
  
  def type
    return 'image' if content_type.include?('image')
    return 'audio' if content_type.include?('audio')
    return 'video' if content_type.include?('video')
  end
  
  private
  
  def set_type_for_embedded_media
    parts = self.filename.split(".")
    if parts.length > 1
      if parts.last == "flv"
        self.content_type = "video/x-flv"
      elsif parts.last == "mp3"
        self.content_type = "audio/x-mp3"
      end
    end
  end
end
