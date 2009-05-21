class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :community_id
      t.string :page_path
      t.string :name
      t.string :title
      t.text :body
      t.boolean :standalone

      t.timestamps
    end
    add_index :pages, [:community_id, :page_path], :unique => true
  end

  def self.down
    drop_table :pages
  end
end
