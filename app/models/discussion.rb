class Discussion < ActiveRecord::Base
  
  validates_presence_of :title, :body
  belongs_to :user
  belongs_to :community
  belongs_to :category
  has_many :responses, :dependent => :destroy
  
  is_indexed :fields => ['title', 'body', 'community_id'] 
  
  alias_attribute :to_s, :title
  
  named_scope :for_category, lambda { | category_id | 
    { :conditions => ({ :category_id => (category_id == 'nil' || category_id == '') ? nil : category_id } if category_id) } 
  }
  
end
