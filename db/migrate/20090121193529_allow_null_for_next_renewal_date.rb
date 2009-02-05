class AllowNullForNextRenewalDate < ActiveRecord::Migration
  def self.up
    change_column :subscriptions, :next_renewal_at, :date, :null => true
  end

  def self.down
    change_column :subscriptions, :next_renewal_at, :date, :null => false
  end
end
