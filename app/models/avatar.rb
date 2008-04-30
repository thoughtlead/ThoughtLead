class Avatar < ActiveRecord::Base
  belongs_to      :user
  has_attachment  :content_type => :image, :storage => :file_system, :thumbnails => { :small => '48x48>', :medium => '64x64>', :large => '100x100>' }, :max_size => 5.megabytes, :processor => (Rails.env == 'staging') ? 'MiniMagick' : 'ImageScience'
  validates_as_attachment

end
