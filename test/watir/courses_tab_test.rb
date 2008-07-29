require File.dirname(__FILE__) + '/watir_test_case'

class CoursesTabTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :courses, :communities
  
  def test_can_add_a_course
    $ie.link(:text, "Add a Course").click
    $ie.text_field(:id, "course_title").set("New Course Title")
    $ie.text_field(:id, "course_description").set("New course description")    
    $ie.form(:action, "/courses").submit    
    
    $ie.link(:text, /Return to Courses/).click
    assert $ie.link(:text, "New Course Title").exist?
    assert $ie.p(:text, "New course description").exist?    
  end
  
  def test_can_edit_exists_and_links
    $ie.link(:text, "Edit").click
    assert $ie.text_field(:id, "course_title").exist?
    assert $ie.text_field(:id, "course_description").exist?
    assert $ie.checkbox(:id, "course_draft").exist?
    assert $ie.form(:action, /courses/).exist?    
  end
  
  def test_draft_course_visibility
    assert $ie.link(:text, (courses :draft).title ).exist?
    assert $ie.p(:text, (courses :draft).description ).exist?
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Courses").click    
    assert !($ie.link(:text, (courses :draft).title ).exist?)
    assert !($ie.p(:text, (courses :draft).description ).exist?)
  end
  
  def test_no_content_tags_when_content_not_visible
    li = $ie.li(:text, /#{(courses :antitagged).title}/)
    #puts "\n\n" + li.text + "\n\n"
    assert li.text.include?("Has Premium Content") && li.text.include?("Has Registered Content") && li.text.include?("Has Draft Content")
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Courses").click    
    li = $ie.li(:text, /#{(courses :antitagged).title}/)
    #puts "\n\n" + li.text + "\n\n"
    assert !li.text.include?("Has Premium Content") && !li.text.include?("Has Registered Content") && !li.text.include?("Has Draft Content")
  end

  def test_has_content_tags
    li = $ie.li(:text, /#{(courses :tagged).title}/)
    #puts "\n\n" + li.text + "\n\n"
    assert li.text.include?("Has Premium Content") && li.text.include?("Has Registered Content") && li.text.include?("Has Draft Content")
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Courses").click    
    li = $ie.li(:text, /#{(courses :tagged).title}/)
    #puts "\n\n" + li.text + "\n\n"
    assert li.text.include?("Has Premium Content") && !li.text.include?("Has Registered Content") && !li.text.include?("Has Draft Content")
  end
  
  private
  
  def setup
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Courses").click    
  end
  
end