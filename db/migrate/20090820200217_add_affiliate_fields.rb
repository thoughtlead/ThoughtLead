class AddAffiliateFields < ActiveRecord::Migration
  def self.up
    add_column :communities, :affiliates_enabled, :boolean, :default => false
    
    add_column :users, :affiliate_code, :string
    add_column :users, :referred_by_id, :integer, :default => nil
    
    add_index :users, :affiliate_code, :unique => true
  end

  def self.down
    remove_column :communities, :affiliates_enabled
    remove_column :users, :affiliate_code
    remove_column :users, :referred_by_id
    remove_index :users, :column => :affiliate_code
  end
end
