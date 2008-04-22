class ExtendUserProfile < ActiveRecord::Migration
  def self.up
    add_column :users, :about, :text
    add_column :users, :interests, :text
    add_column :users, :website_1, :string
    add_column :users, :website_2, :string
    add_column :users, :display_name, :string
    add_column :users, :location, :string
  end

  def self.down
    remove_column :users, :location
    remove_column :users, :display_name
    remove_column :users, :website_2
    remove_column :users, :website_1
    remove_column :users, :interests
    remove_column :users, :about
  end
end
