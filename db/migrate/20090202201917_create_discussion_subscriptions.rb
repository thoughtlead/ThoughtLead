class CreateDiscussionSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :email_subscriptions do |t|
      t.integer :subscriber_id, :null => false
      t.integer :discussion_id, :null => false
    end
  end

  def self.down
    drop_table :email_subscriptions
  end
end
