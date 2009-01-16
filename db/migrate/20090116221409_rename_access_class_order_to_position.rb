class RenameAccessClassOrderToPosition < ActiveRecord::Migration
  def self.up
    rename_column :access_classes, :order, :position
  end

  def self.down
    rename_column :access_classes, :position, :order
  end
end
