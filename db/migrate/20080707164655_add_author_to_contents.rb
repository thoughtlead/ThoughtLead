class AddAuthorToContents < ActiveRecord::Migration
  def self.up
    add_column(:contents, :author, :string, :default=>"")
  end
  
  def self.down
    remove_column(:contents, :author)
  end
end
