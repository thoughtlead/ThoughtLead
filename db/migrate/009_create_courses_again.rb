class CreateCoursesAgain < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.belongs_to :user
      t.belongs_to :community
      
      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
