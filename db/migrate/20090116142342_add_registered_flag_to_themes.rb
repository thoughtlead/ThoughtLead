class AddRegisteredFlagToThemes < ActiveRecord::Migration
   class Community < ActiveRecord::Base
    has_many :themes, :class_name => "AddRegisteredFlagToThemes::Theme"
    has_many :access_classes, :class_name => "AddRegisteredFlagToThemes::AccessClass"
  end

  class AccessClass < ActiveRecord::Base
  end

  class ThemeAccessClass < ActiveRecord::Base
    belongs_to :access_class, :class_name => "AddRegisteredFlagToThemes::AccessClass"
  end

  class Theme < ActiveRecord::Base
    has_many :theme_access_classes, :class_name => "AddRegisteredFlagToThemes::ThemeAccessClass"
    has_many :access_classes, :through => :theme_access_classes
  end

  def self.up
    add_column :themes, :registered, :boolean, :default => false

    Community.all.each do |community|
      community.themes.each do |theme|
        unless theme.access_classes.blank?
          theme.registered = true
          theme.save!
        end
      end
    end
  end

  def self.down
    remove_column :themes, :registered
  end
end
