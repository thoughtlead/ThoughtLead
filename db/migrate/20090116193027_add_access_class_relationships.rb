class AddAccessClassRelationships < ActiveRecord::Migration
  def self.up
    create_table :access_class_relationships do |t|
        t.integer :access_class_id, :null => false
        t.integer :child_id, :null => false
    end
  end

  def self.down
    drop_table :access_class_relationships
  end
end
