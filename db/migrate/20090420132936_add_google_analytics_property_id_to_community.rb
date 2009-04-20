class AddGoogleAnalyticsPropertyIdToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :ga_property_id, :string, :default => nil
  end

  def self.down
    remove_column :communities, :ga_property_id
  end
end
