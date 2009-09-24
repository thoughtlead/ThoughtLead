class AddCopyrightHolderToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :copyright, :string
  end

  def self.down
    remove_column :communities, :copyright
  end
end
