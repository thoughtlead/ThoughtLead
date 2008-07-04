require "random_data"

class LibraryController < ApplicationController
  
  class Article
    attr_accessor :title,:teaser,:user,:date,:body,:video,:attachments
    alias_attribute :to_s, :title    
    def initialize(i)
      self.title = "About " + Random.city
      self.teaser = Random.paragraphs(1)
      self.user = Random.firstname + " " + Random.lastname
      self.date = DateTime.now
      self.body = Random.paragraphs(10)
      case i
        when 2
        self.video = true
        when 5
        self.video = true
      else
        self.video = false
      end      
      self.attachments = []
      case i
        when 3
        attachments << Random.firstname + ".png"
        when 4,5
         ((rand*3).to_i + 2).times do
          attachments << Random.firstname + ".png"        
        end
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
      for i in 1..5 do
        articles << Article.new(i)
      end
    end
  end
  
  if !$library
    $library = [LibraryCategory.new("Lorem"), LibraryCategory.new("Ipsum"), LibraryCategory.new("Dolor"), LibraryCategory.new("Sit"), LibraryCategory.new("Amet")]
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
  end
  
end
