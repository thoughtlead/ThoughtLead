class SearchController < ApplicationController
  
  def index
    processed_search_string = "#{params[:search_string]}"
    
    if (processed_search_string.blank? || processed_search_string == "Search...")
      if(request.env["HTTP_REFERER"].to_s.ends_with?("search"))
        redirect_to(:controller => 'home')
      else
        redirect_back
      end
      return
    end
    
    @results = execute_search(processed_search_string)
    
    if(@results.blank?)
      flash[:notice] = "No exact matches found for \"#{processed_search_string}\". Searching for partial matches."
      flash.discard(:notice)
      processed_search_string = "*#{processed_search_string}*"
      @results = execute_search(processed_search_string)
    else
    end
  
    @courses = @results.find_all{|result| result.class == Course && result.visible_to(current_user)}
    @lessons = @results.find_all{|result| result.class == Content && !result.lesson.nil? && result.lesson.visible_to(current_user)}
    @articles= @results.find_all{|result| result.class == Content && !result.article.nil? && result.article.visible_to(current_user)}
    @discussions = @results.find_all{|result| result.class == Discussion}
    @responses = @results.find_all{|result| result.class == Response }
    @users = @results.find_all{|result| result.class == User }
    
    # Index the lessons by course_id so we can display then nested as necessary
    @lessons_by_course_id = {}
    @lessons.each do |content|
      @lessons_by_course_id[content.lesson.chapter.course_id] ||= []
      @lessons_by_course_id[content.lesson.chapter.course_id] << content
    end
    
    # Index the resoonses by discussion_id so we can display then nested as necissary
    @responses_by_discussion_id = {}
    @responses.each do |response|
      @responses_by_discussion_id[response.discussion_id] ||= []
      @responses_by_discussion_id[response.discussion_id] << response
    end
  
  end
  
  private
  def execute_search search_string
    search = Ultrasphinx::Search.new :query => search_string, :filters => {'community_id' => current_community.id}
    search.excerpt
    return search.results
  end
  
end
