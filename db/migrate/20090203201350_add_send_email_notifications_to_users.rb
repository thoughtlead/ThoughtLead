class AddSendEmailNotificationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :send_email_notifications, :boolean, :default => false
  end

  def self.down
    remove_column :users, :send_email_notifications
  end
end
