class AddAndPopulateChapterOrder < ActiveRecord::Migration
  def self.up
    add_column(:chapters, :order, :integer)
    for chapter in Chapter.find(:all)
      chapter.order = chapter.id
      chapter.save!
    end
  end

  def self.down
    remove_column(:chapters, :order)
  end
end
