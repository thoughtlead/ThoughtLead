class Article < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belong_to :content
  #alias_attribute :to_s, :title
  
end
