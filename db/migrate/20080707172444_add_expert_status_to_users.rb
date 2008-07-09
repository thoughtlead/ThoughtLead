class AddExpertStatusToUsers < ActiveRecord::Migration
  def self.up
    add_column(:users, :expert, :boolean, :default=>false)
  end
  
  def self.down
    remove_column(:users, :expert)
  end
end
