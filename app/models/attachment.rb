class Attachment < ActiveRecord::Base
  belongs_to      :user
  belongs_to      :lesson
  has_attachment  :storage => :s3, :max_size => 25.megabytes
  validates_as_attachment

end
