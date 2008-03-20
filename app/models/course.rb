class Course < ActiveRecord::Base
  validates_presence_of :title, :description

  belongs_to :user
  belongs_to :community
  has_many :articles, :dependent => :destroy

  alias_attribute :to_s, :title
  
end
