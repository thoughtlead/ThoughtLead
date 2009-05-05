class AddAccessClassUserJoinTable < ActiveRecord::Migration
  def self.up
    create_table :user_classes, :force => true do |t|
      t.integer :user_id
      t.integer :access_class_id
    end
    
    add_index :user_classes, [:user_id, :access_class_id], :unique => true
    
    say_with_time "Migrating Access Classes..." do
      User.find(:all).each do |u|
        unless u.access_class_id.blank?
          uc = u.user_classes.find_or_create_by_access_class_id(u.access_class_id)
        end
      end
    end
    
    
    
  end

  def self.down
    remove_index :user_classes, :column => [:user_id, :access_class_id]
    drop_table :user_classes
  end
end
