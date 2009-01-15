class DropSpreedlyColumns < ActiveRecord::Migration
  def self.up
    remove_column :users, :spreedly_token
    remove_column :communities, :spreedly_token
    remove_column :communities, :spreedly_api_key
    remove_column :communities, :use_spreedly_production_site
    remove_column :communities, :eligible_for_free_trial
  end

  def self.down
    add_column :communities, :eligible_for_free_trial, :boolean,      :default => true
    add_column :communities, :use_spreedly_production_site, :boolean, :default => false
    add_column :communities, :spreedly_api_key, :string
    add_column :communities, :spreedly_token, :string
    add_column :users, :spreedly_token, :string
  end
end
