class AddCommunityName < ActiveRecord::Migration
  def self.up
    add_column :communities, :name, :string
  end

  def self.down
    remove_column :communities, :name
  end
end
