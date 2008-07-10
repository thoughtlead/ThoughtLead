class Category < ActiveRecord::Base
  has_and_belongs_to_many :articles, :join_table=>'categorizations'
  belongs_to :community
  validates_presence_of :name
  alias_attribute :to_s, :name
  
  def  contains_articles_visible_to(user)
    return false if articles.to_a.blank?
    articles.each do |article|
      return false unless article.visible_to(user)
    end
    return true
  end
  
end
