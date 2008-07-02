class CreateCategoriesCategorizationsContentsAndArticles < ActiveRecord::Migration
  # TODO handle chapter_position
  
  def self.up
    #contents
    rename_table :lessons, :contents
    create_table :lessons do |t|
      t.belongs_to :content
      t.belongs_to :chapter
      t.integer :chapter_position
      t.timestamps
    end
    
    # Reload column data for the models
    Lesson.reset_column_information
    Content.reset_column_information
    
    # Relate the content-that-used-to-be-a-lesson to the new lesson. move the chapter_id into the new lesson.
    Content.find(:all).each do |content|
      Lesson.new(:content_id => content.id, :chapter_id=>content.chapter_id, :chapter_position=>content.chapter_position).save(false)
    end
    remove_column :contents, :chapter_id
    remove_column :contents, :chapter_position
    
    rename_column :flash_videos, :lesson_id, :content_id
    rename_column :attachments, :lesson_id, :content_id
    
    create_table :categories do |t|
      t.belongs_to :community
      t.string :name
      t.timestamps
    end

    create_table :articles do |t|
      t.belongs_to :community
      t.belongs_to :content
      t.timestamps
    end
    
    # This is the has_and_belongs_to_many join table. It can't have an id column, and should be named 
    #  as the pluralized names of the two related tables. 
    create_table :categories_articles, :id => false do |t|
      t.belongs_to :category
      t.belongs_to :article
    end
    
  end
  
  def self.down
    drop_table :categories_articles
    drop_table :articles
    drop_table :categories

    rename_column :flash_videos, :content_id, :lesson_id
    rename_column :attachments, :content_id, :lesson_id

    add_column :contents, :chapter_id, :integer
    add_column :contents, :chapter_position, :integer
    
    Content.reset_column_information
    Lesson.find(:all).each do |lesson|
      # don't assume the relationships are properly defined for this migration.
      content = Content.find_by_id(lesson.content_id)
      content.attributes = {:chapter_id=>lesson.chapter_id, :chapter_position=>lesson.chapter_position}
      content.save(false)
    end
    drop_table :lessons
    rename_table :contents, :lessons
  end
end
