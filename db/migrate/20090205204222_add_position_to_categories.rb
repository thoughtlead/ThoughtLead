class AddPositionToCategories < ActiveRecord::Migration
  class Community < ActiveRecord::Base
    has_many :categories, :class_name => "AddPositionToCategories::Category"
  end

  class Category < ActiveRecord::Base
  end

  def self.up
    add_column :categories, :position, :integer

    Community.all.each do |community|
      community.categories.each_with_index do |category, index|
        category.position = index + 1
        category.save!
      end
    end
  end

  def self.down
    remove_column :categories, :position
  end
end
