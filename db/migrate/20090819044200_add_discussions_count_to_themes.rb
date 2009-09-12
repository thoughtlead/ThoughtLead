class AddDiscussionsCountToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :discussions_count, :integer
    
    Theme.reset_column_information
    Theme.find(:all).each do |thm|
      disc_cnt = thm.discussions.count
      thm.update_attribute(:discussions_count, disc_cnt)
    end
  end

  def self.down
    remove_column :themes, :discussions_count
  end
end
