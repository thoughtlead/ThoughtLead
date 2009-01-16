class RemoveDiscussionAccessibilityFlag < ActiveRecord::Migration
  class Community < ActiveRecord::Base
    has_many :themes, :class_name => "RemoveDiscussionAccessibilityFlag::Theme"
    has_many :access_classes, :class_name => "RemoveDiscussionAccessibilityFlag::AccessClass"
  end

  class AccessClass < ActiveRecord::Base
  end

  class ThemeAccessClass < ActiveRecord::Base
    belongs_to :access_class, :class_name => "RemoveDiscussionAccessibilityFlag::AccessClass"
  end

  class Theme < ActiveRecord::Base
    has_many :theme_access_classes, :class_name => "RemoveDiscussionAccessibilityFlag::ThemeAccessClass"
    has_many :access_classes, :through => :theme_access_classes
  end

  def self.up
    Community.all.each do |community|
      premium = community.access_classes.find_by_name("Premium")
      if community.discussion_accessibility == 1
        community.themes.each do |theme|
          theme.access_classes << premium unless theme.access_classes.include? premium
          theme.save!
        end
      end
    end

    remove_column :communities, :discussion_accessibility
  end

  def self.down
    add_column :communities, :discussion_accessibility, :integer, :default => 1

    Community.all.each do |community|
        community.themes.each do |theme|
          unless theme.access_classes.blank?
            community.discussion_accessibility = 1
            community.save!
          end
        end
    end
  end
end
