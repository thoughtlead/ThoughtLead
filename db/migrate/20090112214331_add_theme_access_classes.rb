class AddThemeAccessClasses < ActiveRecord::Migration
  def self.up
    create_table :theme_access_classes do |t|
      t.integer :theme_id, :null => false
      t.integer :access_class_id, :null => false
    end
  end

  def self.down
    drop_table :theme_access_classes
  end
end
