class AccessRightsForLessons < ActiveRecord::Migration
  def self.up
    add_column(:lessons, :registered, :boolean, :default=>false)
    change_column_default(:lessons, :draft, true) #how'd that sneak in there?
  end

  def self.down
    remove_column(:lessons, :registered)
    change_column_default(:lessons, :draft, false) #how'd that sneak in there?
  end
end
