class Article < ActiveRecord::Base
  has_and_belongs_to_many :categories, :join_table=>'categorizations'
  belongs_to :content
  belongs_to :community
  before_save :update_new_categories
  
  def to_s
   (content && content.title) || ""
  end
  
  def article_categories=(it)
    self.categories = []
    for category_id in it.uniq
      unless category_id.blank?
        self.categories << Category.find_by_id(category_id)
      end
    end
  end
  
  def article_new_categories=(it)
    #to be completed before save, so that we know all other work (which may be inter-dependent) is completed
    @new_category_names = it.uniq
  end
  
  def visible_to(user)
    !self.content.draft? || user == self.community.owner
  end
  
  def accessible_to(user)
    return false unless visible_to(user)
    return true if user == self.community.owner
    #Authenticated System uses :false when there is no current_user
    if (user == :false) && (self.content.premium? || self.content.registered?)
      return false
    end
    if self.content.premium?
      return user.active?
    end
    if self.content.registered? 
      return !user.nil?
    end
    return true    
  end
  
  #  named_scope :for_category, lambda { | category_id | 
  #    { :conditions => ({ :category_id => (category_id == 'nil' || category_id == '') ? nil : category_id } if category_id) } 
  #  }
  
  named_scope :for_category, lambda { | category_id | 
    
    { :include=>:categories, :conditions => ({ 'categories.id' => (category_id == 'nil' || category_id == '') ? nil : category_id } if category_id) } 
  }
  
  def notes
    s = []
    if self.content.premium
      s << "Premium"
    end
    if self.content.registered
      s << "Registered"
    end
    if self.content.draft
      s << "Draft"
    end
    return s * "; "
  end
  
  private
  
  def update_new_categories()
    unless @new_category_names.blank?
      @new_category_names.each do |new_category_name|
        unless new_category = Category.find_by_name_and_community_id(new_category_name,self.community.id)
          new_category = Category.new(:name=>new_category_name, :community_id=>self.community.id)
          new_category.save
        end
        unless self.categories.to_a.include?(new_category)
          self.categories << new_category
        end
      end
    end
  end
  
  
end
