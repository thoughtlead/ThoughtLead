class ContentAccessClass < ActiveRecord::Base
  belongs_to :content
  belongs_to :access_class 
end