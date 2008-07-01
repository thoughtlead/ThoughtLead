class RenameCategoriesToThemes < ActiveRecord::Migration
  def self.up
    rename_table(:categories, :themes)
    rename_column(:discussions, :category_id, :theme_id)
  end

  def self.down
    rename_table(:themes, :categories)
    rename_column(:discussions, :theme_id, :category_id)
  end
end
