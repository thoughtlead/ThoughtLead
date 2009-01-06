class AddMembershipLevel < ActiveRecord::Migration
  class Content < ActiveRecord::Base
  end

  class Article < ActiveRecord::Base
    belongs_to :content, :class_name => "AddMembershipLevel::Content"
  end
  
  class Lesson < ActiveRecord::Base
    belongs_to :content, :class_name => "AddMembershipLevel::Content"
  end

  class Chapter < ActiveRecord::Base
    has_many :lessons, :class_name => "AddMembershipLevel::Lesson"
  end
  
  class Course < ActiveRecord::Base
    has_many :chapters, :class_name => "AddMembershipLevel::Chapter"    
  end
  
  class User < ActiveRecord::Base
  end

  class MembershipLevel < ActiveRecord::Base
  end

  class Community < ActiveRecord::Base
    has_many :users, :class_name => "AddMembershipLevel::User"
    has_many :articles, :class_name => "AddMembershipLevel::Article"
    has_many :courses, :class_name => "AddMembershipLevel::Course"
  end

  def self.up
    create_table :membership_levels do |t|
      t.integer :community_id, :null => false
      t.string :name, :null => false
      t.decimal :price, :precision => 10, :scale => 2, :null => false
      t.integer :order, :null => false
      t.timestamps
    end
    
    add_column :users, :membership_level_id, :integer, :null => true
    add_column :contents, :membership_level_id, :integer, :null => true
    add_column :themes, :membership_level_id, :integer, :null => true
    
    Community.all.each do |community|
      premium = MembershipLevel.create(:name => "Premium", :price => 9_999_999, :order => 1, :community_id => community.id)
      
      community.users.each do |user| 
        user.membership_level_id = user.active ? premium.id : nil
        user.save!
      end
      
      community.articles.each do |article|  
        content = article.content
        content.membership_level_id = content.premium ? premium.id : nil
        content.save!
      end

      community.courses.each do |course|  
        course.chapters.each do |chapter|
          chapter.lessons.each do |lesson|  
            content = lesson.content
            content.membership_level_id = content.premium ? premium.id : nil
            content.save!
          end
        end
      end  
    end
    
    remove_column :users, :active
    remove_column :contents, :premium
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
