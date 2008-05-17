class CleanUpSpreedlyIntegration < ActiveRecord::Migration
  def self.up
    remove_column :communities, :spreedly_community_name
    add_column :communities, :use_spreedly_production_site, :boolean, :default => false
  end

  def self.down
    remove_column :communities, :use_spreedly_production_site
    add_column :communities, :spreedly_community_name, :string
  end
end
