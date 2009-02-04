class AddPositionToThemes < ActiveRecord::Migration
  class Community < ActiveRecord::Base
    has_many :themes, :class_name => "AddPositionToThemes::Theme"
  end

  class Theme < ActiveRecord::Base
  end

  def self.up
    add_column :themes, :position, :integer

    Community.all.each do |community|
      community.themes.each_with_index do |theme, index|
        theme.position = index + 1
        theme.save!
      end
    end
  end

  def self.down
    remove_column :themes, :position
  end
end
