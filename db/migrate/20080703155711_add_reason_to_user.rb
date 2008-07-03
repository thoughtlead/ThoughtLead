class AddReasonToUser < ActiveRecord::Migration
  def self.up
    add_column(:users, :reason, :text)
  end

  def self.down
    remove_column(:users, :reason)
  end
end
