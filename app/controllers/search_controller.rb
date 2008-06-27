class SearchController < ApplicationController
  
  def index
    processed_search_string = "*#{params[:search_string]}*"
    @search = Ultrasphinx::Search.new(:query => processed_search_string, :filters => {'community_id' => current_community.id})
    @search.run
    
    @results = @search.results
  
    @courses = @results.find_all{|result| result.class == Course }
    @lessons = @results.find_all{|result| result.class == Lesson }
    @discussions = @results.find_all{|result| result.class == Discussion }
  
  end
  
end
