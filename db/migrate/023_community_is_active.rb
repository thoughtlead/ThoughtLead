class CommunityIsActive < ActiveRecord::Migration
  def self.up
    add_column :communities, :active, :boolean, :default => false
    add_column :communities, :eligible_for_free_trial, :boolean, :default => true
  end

  def self.down
    remove_column :communities, :eligible_for_free_trial
    remove_column :communities, :active
  end
end
