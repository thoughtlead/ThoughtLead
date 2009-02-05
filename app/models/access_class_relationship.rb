class AccessClassRelationship < ActiveRecord::Base
  belongs_to :access_class
  belongs_to :child, :class_name => 'AccessClass'
end
