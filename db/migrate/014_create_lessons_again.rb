class CreateLessonsAgain < ActiveRecord::Migration
  def self.up
    create_table :lessons do |t|
      t.string :title
      t.text :body

      t.belongs_to :chapter
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :chapters
  end
end
