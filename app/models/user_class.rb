class UserClass < ActiveRecord::Base
  set_table_name 'user_classes'
  belongs_to :user
  belongs_to :access_class
end
