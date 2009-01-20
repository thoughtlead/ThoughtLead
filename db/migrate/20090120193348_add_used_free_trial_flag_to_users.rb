class AddUsedFreeTrialFlagToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :trial_available, :boolean, :default => true
  end

  def self.down
    remove_column :users, :trial_available
  end
end
