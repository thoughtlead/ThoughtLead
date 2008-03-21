class CreateChapters < ActiveRecord::Migration
  def self.up
    create_table :chapters do |t|
      t.belongs_to :course
      t.timestamps
    end
  end

  def self.down
    drop_table :chapters
  end
end
