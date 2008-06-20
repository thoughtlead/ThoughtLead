class FlashVideo < ActiveRecord::Base
  belongs_to      :user
  belongs_to      :lesson
  has_attachment  :storage => :s3, :max_size => 25.megabytes, :s3_access => :authenticated_read
  validates_as_attachment

  def attachment_attributes_valid?
    errors.add_to_base("Uploaded file is too large (25MB max).") if attachment_options[:size] && !attachment_options[:size].include?(send(:size))
    errors.add_to_base("Uploaded file has invalid content.") if attachment_options[:content_type] && !attachment_options[:content_type].include?(send(:content_type))
  end 
end