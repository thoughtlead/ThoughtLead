class AddPremiumLinkToCommunity < ActiveRecord::Migration
  def self.up
    add_column(:communities, :premium_link, :string)
    add_column(:communities, :premium_text, :string)
  end

  def self.down
    remove_column(:communities, :premium_link)
    remove_column(:communities, :premium_text)
  end
end
