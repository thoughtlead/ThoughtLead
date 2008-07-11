class SearchController < ApplicationController
  
  def index
    processed_search_string = "#{params[:search_string]}"
    @search = Ultrasphinx::Search.new(:query => processed_search_string, :filters => {'community_id' => current_community.id})
    @search.excerpt
    
    @results = @search.results
  
    @courses = @results.find_all{|result| result.class == Course && result.visible_to(current_user)}
    @lessons = @results.find_all{|result| result.class == Content && !result.lesson.nil? && result.lesson.visible_to(current_user)}.collect(&:lesson)
    @articles= @results.find_all{|result| result.class == Content && !result.article.nil? && result.article.visible_to(current_user) }.collect(&:article)
    @discussions = @results.find_all{|result| result.class == Discussion}
    @responses = @results.find_all{|result| result.class == Response }
    @users = @results.find_all{|result| result.class == User }
    
    # Index the lessons by course_id so we can display then nested as necissary
    @lessons_by_course_id = {}
    @lessons.each do |lesson|
      @lessons_by_course_id[lesson.chapter.course_id] ||= []
      @lessons_by_course_id[lesson.chapter.course_id] << lesson
    end
    
    # Index the resoonses by discussion_id so we can display then nested as necissary
    @responses_by_discussion_id = {}
    @responses.each do |response|
      @responses_by_discussion_id[response.discussion_id] ||= []
      @responses_by_discussion_id[response.discussion_id] << response
    end
  
  end
  
end
