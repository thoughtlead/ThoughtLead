class ChangeContentBodySizeToLongtext < ActiveRecord::Migration
  def self.up
    change_column :contents, :body, :text, :limit => 16.megabytes
  end

  def self.down
    change_column :contents, :body, :text
  end
end
