class DropCourses < ActiveRecord::Migration
  def self.up
    drop_table :courses
  end

  def self.down
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.timestamps
    end
  end
end
