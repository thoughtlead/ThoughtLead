class AddFlixcloudFieldsToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :job_id, :integer
    add_column :attachments, :job_status, :string
    add_column :attachments, :job_comments, :text
  end

  def self.down
    remove_column :attachments, :job_id
    remove_column :attachments, :job_status
    remove_column :attachments, :job_comments
  end
end
