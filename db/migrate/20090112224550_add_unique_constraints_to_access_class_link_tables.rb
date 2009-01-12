class AddUniqueConstraintsToAccessClassLinkTables < ActiveRecord::Migration
  def self.up
    add_index :content_access_classes, [:content_id, :access_class_id], :unique => true
    add_index :theme_access_classes, [:theme_id, :access_class_id], :unique => true
  end

  def self.down
    remove_index :theme_access_classes, :column => [:theme_id, :access_class_id]
    remove_index :content_access_classes, :column => [:content_id, :access_class_id]
  end
end
