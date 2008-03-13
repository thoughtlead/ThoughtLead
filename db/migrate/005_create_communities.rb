class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.string :subdomain
      t.integer :owner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
