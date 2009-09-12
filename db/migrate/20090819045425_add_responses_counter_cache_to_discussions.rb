class AddResponsesCounterCacheToDiscussions < ActiveRecord::Migration
  def self.up
    add_column :discussions, :responses_count, :integer
    
    say_with_time "Updating response counts..." do
      Discussion.reset_column_information
      Discussion.find(:all).each do |disc|
        resp_cnt = disc.responses.count
        disc.update_attribute(:responses_count, resp_cnt)
      end
    end
  end

  def self.down
    remove_column :discussions, :responses_count
  end
end
