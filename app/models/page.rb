class Page < ActiveRecord::Base
  belongs_to :community
  
  named_scope :active,    :conditions => { :active => true }
  named_scope :inactive,  :conditions => { :active => false }
  named_scope :user_defined, :conditions => { :system => false }
  
  def to_param
    page_path
  end
end
