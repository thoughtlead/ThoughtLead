class CommunitySpreedlyApiKey < ActiveRecord::Migration
  def self.up
    add_column :communities, :spreedly_api_key, :string
    add_column :communities, :spreedly_community_name, :string
  end

  def self.down
    remove_column :communities, :spreedly_community_name
    remove_column :communities, :spreedly_api_key
  end
end
