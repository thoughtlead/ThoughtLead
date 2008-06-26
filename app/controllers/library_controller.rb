require "random_data"

class LibraryController < ApplicationController
  
  class Article
    attr_accessor :title,:teaser,:user,:date,:body,:video,:attachments
    alias_attribute :to_s, :title    
    def initialize()
      self.title = "About " + Random.city
      self.teaser = Random.paragraphs(1)
      self.user = Random.firstname + " " + Random.lastname
      self.date = DateTime.now
      self.body = Random.paragraphs(10)
      self.video = rand > 0.5
      self.attachments = []
      ((rand*6).to_i - 2).times do
        attachments << Random.firstname + ".png"        
      end
    end
  end
  
  class LibraryCategory
    attr_accessor :title
    alias_attribute :to_s, :title
    attr_accessor :articles
    def initialize(title)
      self.title = title
      self.articles = []
    end
  end
  
  if !$library 
    $library = [LibraryCategory.new(Random.country), LibraryCategory.new(Random.country), LibraryCategory.new(Random.country), LibraryCategory.new(Random.country), LibraryCategory.new(Random.country)]
  end
  
  def index
  end
  
  def show
    @category = $library[0]
  end
  
  def edit
    @category = $library[0]    
  end
  
  def new
    @category = $library[0]
  end
  
  def new_article
    @category = $library[0]
    @category.articles << Article.new()
    redirect_to "/library/show"
  end
end
