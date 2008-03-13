class RemoveLessons < ActiveRecord::Migration
  def self.up
    drop_table :lessons
  end

  def self.down
    create_table :lessons do |t|
      t.string :title
      t.text :body
      t.integer :course_id
      t.timestamps
    end
  end
end
