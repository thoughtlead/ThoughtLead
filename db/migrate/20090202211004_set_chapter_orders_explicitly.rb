class SetChapterOrdersExplicitly < ActiveRecord::Migration
  class Course < ActiveRecord::Base
    has_many :chapters, :class_name => "SetChapterOrdersExplicitly::Chapter"
  end

  class Chapter < ActiveRecord::Base
  end

  def self.up
    Course.all.each do |course|
      course.chapters.each_with_index do |chapter, index|
        chapter.position = index + 1
        chapter.save!
      end
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
