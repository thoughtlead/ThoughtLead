class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.belongs_to :community
      t.string :name
      t.timestamps
    end
    
    add_column :discussions, :category_id, :integer
  end

  def self.down
    remove_column :discussions, :category_id
    drop_table :categories
  end
end
