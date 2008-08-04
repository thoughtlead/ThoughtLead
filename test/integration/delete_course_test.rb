require File.dirname(__FILE__) + '/../test_helper' 

class DeleteCourseTest < ActionController::IntegrationTest
  fixtures :users, :courses, :communities

  context "A Course" do
    should "be deletable" do
      new_session_as(:duff) do
        get '/courses'
        assert_select("ul.courses>li", :count => 1)
        assert_select("ul.courses>li>div.title>h2>a", "Liberty is no more")
        get course_url(courses(:liberty))
        assert_link_exists("Delete Course")
        delete course_url(courses(:liberty))
        assert_redirected_to courses_url
        follow_redirect!
        assert_select("ul.courses>li", :count => 0)
        assert_flash("Successfully deleted the course named 'Liberty is no more'")
      end
    end
    
    should "not be deletable if you're not the owner of the community" do
      new_session_as(:alex) do
        get course_url(courses(:liberty))
        assert_link_does_not_exist("Delete Course")
        delete course_url(courses(:liberty))
        assert_redirected_to login_url
        follow_redirect!
        assert_flash("You do not have permission to access that part of the site.")
        
        get '/courses'
        assert_select("ul.courses>li", :count => 1)
      end
    end
  end
      
end
