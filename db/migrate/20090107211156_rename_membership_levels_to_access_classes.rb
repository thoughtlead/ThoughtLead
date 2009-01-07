class RenameMembershipLevelsToAccessClasses < ActiveRecord::Migration

def self.up
  rename_table :membership_levels, :access_classes
  rename_column :contents, :membership_level_id, :access_class_id
  rename_column :users, :membership_level_id, :access_class_id
  rename_column :themes, :membership_level_id, :access_class_id
end

def self.down
  rename_table :access_classes, :membership_levels
  rename_column :contents, :access_class_id, :membership_level_id
  rename_column :users, :access_class_id, :membership_level_id
  rename_column :themes, :access_class_id, :membership_level_id
end

end
