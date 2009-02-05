class AddDescriptionToAccessClasses < ActiveRecord::Migration
  def self.up
    add_column :access_classes, :description, :text
  end

  def self.down
    remove_column :access_classes, :description
  end
end
