class AddDraftToChapters < ActiveRecord::Migration
  def self.up
    add_column(:chapters, :draft, :boolean, :default=>true)
  end

  def self.down
    remove_column(:chapters, :draft)
  end
end
