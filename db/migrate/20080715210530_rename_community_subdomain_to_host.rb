class RenameCommunitySubdomainToHost < ActiveRecord::Migration
  def self.up
    rename_column(:communities, :subdomain, :host)
  end

  def self.down
    rename_column(:communities, :host, :subdomain)
  end
end
