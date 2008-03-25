class EnhanceLesson < ActiveRecord::Migration
  def self.up
    add_column :lessons, :draft, :boolean, :default => false
    add_column :lessons, :teaser, :text
    add_column :lessons, :premium, :boolean, :default => false
  end

  def self.down
    remove_column :lessons, :premium
    remove_column :lessons, :teaser
    remove_column :lessons, :draft
  end
end
