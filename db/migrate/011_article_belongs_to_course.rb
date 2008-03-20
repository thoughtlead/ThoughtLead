class ArticleBelongsToCourse < ActiveRecord::Migration
  def self.up
    add_column :articles, :course_id, :integer
  end

  def self.down
    remove_column :articles, :course_id
  end
end
