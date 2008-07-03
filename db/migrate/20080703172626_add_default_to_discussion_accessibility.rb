class AddDefaultToDiscussionAccessibility < ActiveRecord::Migration
  def self.up
    remove_column(:communities, :discussion_accessibility)
    add_column(:communities, :discussion_accessibility, :integer, :default=>1)
  end
  
  def self.down
    remove_column(:communities, :discussion_accessibility)
    add_column(:communities, :discussion_accessibility, :integer)
  end
end
