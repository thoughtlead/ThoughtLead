class RenameLessonChapterPositionToJustPosition < ActiveRecord::Migration
  def self.up
    rename_column :lessons, :chapter_position, :position
  end

  def self.down
    rename_column :lessons, :position, :chapter_position
  end
end
