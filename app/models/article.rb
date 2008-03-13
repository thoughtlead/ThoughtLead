class Article < ActiveRecord::Base
  validates_presence_of :title, :body

  belongs_to :user
  belongs_to :community

  alias_attribute :to_s, :title
  
end
