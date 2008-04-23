class AddAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars, :force => true do | t |
      t.integer  :user_id
      t.string   :content_type
      t.string   :filename
      t.string   :thumbnail
      t.integer  :size
      t.integer  :width
      t.integer  :height
      t.integer  :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :avatars
  end
end
