class RenameCategoriesArticles < ActiveRecord::Migration
  def self.up
    rename_table(:categories_articles,:categorizations)
  end

  def self.down
    rename_table(:categorizations,:categories_articles)
  end
end
