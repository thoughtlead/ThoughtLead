class AddPandaIdFieldToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :panda_id, :string
  end

  def self.down
    remove_column :attachments, :panda_id
  end
end
