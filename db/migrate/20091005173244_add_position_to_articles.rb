class AddPositionToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :position, :integer, :default => 0
    add_index :articles, [:community_id, :position], :name => "community_position"
  end

  def self.down
    remove_index :articles, :name => :community_position
    remove_column :articles, :position
  end
end
