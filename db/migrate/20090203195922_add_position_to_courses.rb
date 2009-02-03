class AddPositionToCourses < ActiveRecord::Migration
  class Community < ActiveRecord::Base
    has_many :courses, :class_name => "AddPositionToCourses::Course"
  end

  class Course < ActiveRecord::Base
  end

  def self.up
    add_column :courses, :position, :integer

    Community.all.each do |community|
      community.courses.each_with_index do |course, index|
        course.position = index + 1
        course.save!
      end
    end
  end

  def self.down
    remove_column :courses, :position
  end
end
