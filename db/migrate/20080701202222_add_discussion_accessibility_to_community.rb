class AddDiscussionAccessibilityToCommunity < ActiveRecord::Migration
  def self.up
    add_column(:communities, :discussion_accessibility, :integer)
  end

  def self.down
    remove_column(:communities, :discussion_accessibility)
  end
end
