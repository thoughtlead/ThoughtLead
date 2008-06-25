class AddDraftToCourses < ActiveRecord::Migration
  def self.up
    add_column(:courses, :draft, :boolean, :default=>true)
  end

  def self.down
    remove_column(:courses, :draft)
  end
end
