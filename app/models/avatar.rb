class Avatar < ActiveRecord::Base
  belongs_to      :user
  has_attachment  :content_type => :image, :storage => :file_system, :thumbnails => { :small => '48x48>', :medium => '64x64>', :large => '100x100>' }, :max_size => 1.megabytes, :processor => (Rails.env == 'staging') ? 'MiniMagick' : 'ImageScience'
  validates_as_attachment


  def attachment_attributes_valid?
    errors.add_to_base("Uploaded file is too large (25MB max).") if attachment_options[:size] && !attachment_options[:size].include?(send(:size))
    errors.add_to_base("Uploaded file has invalid content.") if attachment_options[:content_type] && !attachment_options[:content_type].include?(send(:content_type))
  end

end
