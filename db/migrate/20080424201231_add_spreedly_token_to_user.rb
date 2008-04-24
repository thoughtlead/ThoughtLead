class AddSpreedlyTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :spreedly_token, :string
  end

  def self.down
    remove_column :users, :spreedly_token
  end
end
