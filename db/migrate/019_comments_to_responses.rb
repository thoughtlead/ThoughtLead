class CommentsToResponses < ActiveRecord::Migration
  def self.up
    rename_table :comments, :responses
  end

  def self.down
    rename_table :responses, :comments
  end
end
