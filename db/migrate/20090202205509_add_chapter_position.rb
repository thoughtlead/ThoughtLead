class AddChapterPosition < ActiveRecord::Migration
  def self.up
    add_column :chapters, :position, :integer
  end

  def self.down
    remove_column :chapters, :position
  end
end
