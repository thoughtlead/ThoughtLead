class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments, :force => true do |t|
      t.belongs_to :user
      t.belongs_to :lesson
      t.string   "content_type"
      t.string   "filename"
      t.integer  "size"
      t.integer  "parent_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
