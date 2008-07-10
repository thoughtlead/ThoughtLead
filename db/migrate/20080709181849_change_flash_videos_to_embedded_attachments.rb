class ChangeFlashVideosToEmbeddedAttachments < ActiveRecord::Migration
  
  def self.up
    #This migration destroys all currently existing flash videos
    ActiveRecord::Base.transaction do
      add_column(:attachments, :embedded, :boolean, :default=>false)      
      
      drop_table :flash_videos
    end    
  end
  def self.down
    #The flash videos cannot be moved back and forth between attachments
    raise ActiveRecord::IrreversibleMigration
    #The following doesn't work
    #    ActiveRecord::Base.transaction do
    #      create_table :flash_videos do |t|
    #        t.belongs_to :user
    #        t.belongs_to :content
    #        t.string   "content_type"
    #        t.string   "filename"
    #        t.integer  "size"
    #        t.integer  "parent_id"
    #        t.timestamps
    #      end
    #      
    #      FlashVideo.reset_column_information
    #      Attachment.find(:all).each do |a|
    #        if a.embedded?
    #          fv = FlashVideo.new
    #          fv.uploaded_data = File.new(a.s3_url)
    #          fv.save
    #          a.destroy
    #        end
    #      end    
    #      
    #      remove_column(:attachments, :embedded)
    #    end    
  end
end
