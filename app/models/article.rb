class Article < ActiveRecord::Base
  validates_presence_of :title, :body

  belongs_to :user
  belongs_to :community
  belongs_to :course

  alias_attribute :to_s, :title
  
end
