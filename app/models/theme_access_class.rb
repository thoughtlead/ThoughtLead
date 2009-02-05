class ThemeAccessClass < ActiveRecord::Base
  belongs_to :theme
  belongs_to :access_class 
end