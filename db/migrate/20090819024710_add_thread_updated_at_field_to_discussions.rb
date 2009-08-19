class AddThreadUpdatedAtFieldToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :thread_last_updated_at, :timestamp
    
    Discussion.reset_column_information
    say_with_time "Updating last updated times..." do
      Discussion.find(:all).each do |disc|
        if disc.responses.empty? 
          last_update = disc.created_at
        else
          last_update = disc.responses.find(:last).created_at
        end
        disc.update_attribute(:thread_last_updated_at, last_update)
      end
    end
    
  end

  def self.down
    remove_column :discussions, :thread_last_updated_at
  end
end
