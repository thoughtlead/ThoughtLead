class AddSystemBooleanFieldToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :system, :boolean, :default => false
    add_column :pages, :active, :boolean, :default => true
    # Update index to include active flag
    remove_index :pages, :name => :community_pages 
    add_index :pages, [:community_id, :page_path, :active], :name => "active_pages", :unique => true
  end

  def self.down
    remove_index :pages, :name => :active_pages
    add_index :pages, [:community_id, :page_path], :name => "community_pages", :unique => true
    
    remove_column :pages, :system
    remove_column :pages, :active
  end
end
