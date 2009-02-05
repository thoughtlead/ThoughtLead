class DropPriceFromAccessClass < ActiveRecord::Migration
  def self.up
    remove_column :access_classes, :price
  end

  def self.down
    add_column :access_classes, :price, :decimal,        :precision => 10, :scale => 2, :null => false
  end
end
