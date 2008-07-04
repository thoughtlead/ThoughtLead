class Category < ActiveRecord::Base
  has_and_belongs_to_many :articles, :join_table=>'categorizations'
  belongs_to :community
  validates_presence_of :name
  alias_attribute :to_s, :name
  
end
