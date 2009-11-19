class AddActivatedToAccessClasses < ActiveRecord::Migration
  def self.up
    add_column :access_classes, :activated, :boolean, :default => true
  end

  def self.down
    remove_column :access_classes, :activated
  end
end
