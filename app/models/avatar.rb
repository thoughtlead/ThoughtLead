class Avatar < ActiveRecord::Base

  belongs_to      :user
  has_attachment  :content_type => :image, :storage => :file_system, :thumbnails => { :small => IMAGE_DIMENSIONS[:small] + '>', :medium => IMAGE_DIMENSIONS[:medium] + '>', :large => IMAGE_DIMENSIONS[:large] + '>' }, :max_size => 10.megabytes, :processor => 'ImageScience'
  validates_as_attachment


  def after_initialize
    if new_record? && !parent_id.nil?
      self.user = Avatar.find_by_id(parent_id).user
    end
  end

  def community
    user.community if user
  end

  def attachment_attributes_valid?
    errors.add_to_base("Uploaded file is too large (10MB max).") if attachment_options[:size] && !attachment_options[:size].include?(send(:size))
    errors.add_to_base("Uploaded file has invalid content.") if attachment_options[:content_type] && !attachment_options[:content_type].include?(send(:content_type))
  end

end
