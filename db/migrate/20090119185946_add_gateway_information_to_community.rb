class AddGatewayInformationToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :gateway_login, :string
    add_column :communities, :gateway_password, :string
  end

  def self.down
    remove_column :communities, :gateway_password
    remove_column :communities, :gateway_login
  end
end
