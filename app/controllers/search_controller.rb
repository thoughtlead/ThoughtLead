class SearchController < ApplicationController
  
  def index
    processed_search_string = "#{params[:search_string]}"
    @search = Ultrasphinx::Search.new(:query => processed_search_string, :filters => {'community_id' => current_community.id})
    @search.excerpt
    
    @results = @search.results
  
    @courses = @results.find_all{|result| result.class == Course }
    @lessons = @results.find_all{|result| result.class == Lesson }
    @discussions = @results.find_all{|result| result.class == Discussion }
    @users = @results.find_all{|result| result.class == User }
    
    # Index the lessons by course_id so we can display then nested as necissary
    @lessons_by_course_id = {}
    @lessons.each do |lesson|
      @lessons_by_course_id[lesson.chapter.course_id] ||= []
      @lessons_by_course_id[lesson.chapter.course_id] << lesson
    end
  
  end
  
end
