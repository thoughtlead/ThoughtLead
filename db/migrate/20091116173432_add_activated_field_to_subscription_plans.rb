class AddActivatedFieldToSubscriptionPlans < ActiveRecord::Migration
  def self.up
    add_column :subscription_plans, :activated, :boolean, :default => true
  end

  def self.down
    remove_column :subscription_plans, :activated
  end
end
