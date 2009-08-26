class CreateAffiliateActions < ActiveRecord::Migration
  def self.up
    create_table :affiliate_actions do |t|
      t.integer :referrer_id
      t.integer :referred_id
      t.string :action

      t.timestamps
    end
    
    add_index :affiliate_actions, [:referrer_id, :action], :name => "referrer_action"
  end

  def self.down
    drop_table :affiliate_actions
    remove_index :affiliate_actions, :name => :referrer_action
  end
end
