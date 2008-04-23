class Avatar < ActiveRecord::Base
  belongs_to      :user
  has_attachment  :content_type => :image, :storage => :file_system, :thumbnails => { :small => '48x48>', :medium => '64x64>', :large => '128x128>' }, :max_size => 5.megabytes, :processor => 'ImageScience'
  validates_as_attachment

end
