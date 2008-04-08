class LessonsActAsList < ActiveRecord::Migration
  def self.up
    add_column :lessons, :chapter_position, :integer
    
    Chapter.find(:all).each do | chapter |
      lessons = chapter.lessons.find(:all, :order => "created_at")
      i = 1
      
      lessons.each do | lesson |
        lesson.chapter_position = i
        lesson.save!
        i += 1
      end
    end
    
  end

  def self.down
    remove_column :lessons, :chapter_position
  end
end
