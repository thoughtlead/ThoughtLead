class ArticlesDoNotBelongToCommunity < ActiveRecord::Migration
  def self.up
    remove_column :articles, :community_id
  end

  def self.down
    add_column :articles, :community_id, :integer
  end
end
