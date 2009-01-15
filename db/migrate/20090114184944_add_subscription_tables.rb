class AddSubscriptionTables < ActiveRecord::Migration
  def self.up
    create_table :subscription_plans do |t|
      t.string :name, :null => false
      t.decimal :amount, :precision => 10, :scale => 2, :null => false
      t.integer :renewal_period, :null => false
      t.string :renewal_units, :null => false
      t.integer :trial_period, :null => false
      t.string :trial_units, :null => false
      t.integer :access_class_id, :null => false
      t.timestamps
    end

    create_table :subscriptions do |t|
      t.integer :user_id, :null => false
      t.integer :subscription_plan_id, :null => true
      t.decimal :amount, :precision => 10, :scale => 2, :null => false
      t.integer :renewal_period, :null => false
      t.string :renewal_units, :null => false
      t.integer :access_class_id, :null => false
      t.string :state, :null => false
      t.date :next_renewal_at, :null => false
      t.string :card_number
      t.string :card_expiration
      t.string :billing_id
      t.timestamps
    end

    create_table :subscription_payments do |t|
      t.integer :user_id, :null => false
      t.string  :description, :null => false
      t.decimal :amount, :precision => 10, :scale => 2, :null => false
      t.string :transaction_id
      t.timestamps
    end
  end

  def self.down
    drop_table :subscription_payments
    drop_table :subscriptions
    drop_table :subscription_plans
  end
end
