class AddContentAccessClasses < ActiveRecord::Migration
  def self.up
    create_table :content_access_classes do |t|
      t.integer :content_id, :null => false
      t.integer :access_class_id, :null => false
    end
  end

  def self.down
    drop_table :content_access_classes
  end
end
