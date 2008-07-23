require File.dirname(__FILE__) + '/watir_test_case'

class CoursePageTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :courses, :communities, :lessons, :chapters

#  def test_work_to_do
#    assert false
#  end
  
  def test_edit_course
    li = $ie.li(:text, /#{(courses :draft).title}/)
    #puts "\n\n" + li.text + "\n\n"
    assert li.text.include?((courses :draft).description) && li.text.include?("Draft") && !li.text.include?("Has Draft Content")
    $ie.link(:text, (courses :draft).title).click    
    assert $ie.h1(:text, (courses :draft).title).exist?
    assert $ie.p(:text, (courses :draft).description).exist?
    assert $ie.span(:text, "Draft: course contents are hidden.").exist?
    $ie.link(:text, "Edit this Course").click
    $ie.text_field(:id, "course_title").set("an edited course")
    $ie.text_field(:id, "course_description").set("the edited course description")    
    $ie.checkbox(:id, "course_draft").click
    $ie.form(:action, /courses/).submit
    assert $ie.h1(:text, "an edited course").exist?
    assert $ie.p(:text, "the edited course description").exist?
    assert !($ie.span(:text, "Draft: course contents are hidden").exist?)
    $ie.link(:text, /Return to Courses/).click
    li = $ie.li(:text, /an edited course/)
    #puts "\n\n" + li.text + "\n\n"
    assert li.text.include?("the edited course description") && (!li.text.include?("Draft") || li.text.include?("Has Draft Content"))
  end
  
  def test_edit_chapters
    $ie.link(:text, (courses :draft).title).click
    $ie.link(:text, "Edit Chapters").click
    
    $ie.text_field(:id, "chapter_name").set("a new chapter")
    $ie.form(:action, /chapters/).submit
    
    $ie.link(:text, /Return to Course Overview/).click
    div = $ie.div(:id, "primary").div(:text, /A NEW CHAPTER/i)
    #puts "\n\n" + div.text + "\n\n"
    assert div.text.include?("Draft")
    
    $ie.link(:text, "Edit Chapters").click    
    div = $ie.span(:text, /A NEW CHAPTER/i).parent
    #puts "\n\n" + div.text + "\n\n"
    assert div.text.include?("Draft")
    
    div.link(:text,"Edit").click
    $ie.text_field(:id, "chapter_name").set("an edited chapter")
    $ie.checkbox(:id, "chapter_draft").click
    $ie.form(:action, /chapters/).submit

    $ie.link(:text, /Return to Course Overview/).click
    assert !($ie.div(:id, "primary").div(:text, /A NEW CHAPTER/i).exist?)
    div = $ie.div(:id, "primary").div(:text, /AN EDITED CHAPTER/i)
    #puts "\n\n" + div.text + "\n\n"
    assert !div.text.include?("Draft")

    $ie.link(:text, "Edit Chapters").click    
    assert !($ie.span(:text, /A NEW CHAPTER/i).exist?)
    div = $ie.span(:text, /AN EDITED CHAPTER/i).parent
    #puts "\n\n" + div.text + "\n\n"
    div.link(:text,"Delete").click
    assert !($ie.span(:text, /AN EDITED CHAPTER/i).exist?)
    $ie.link(:text, /Return to Course Overview/).click
    assert !($ie.div(:id, "primary").div(:text, /AN EDITED CHAPTER/i).exist?)
  end
  
  def test_delete_a_course
    $ie.link(:text, (courses :draft).title).click
    $ie.link(:text, "Delete this Course").click
    assert !($ie.link(:text, (courses :draft).title).exist?)
  end

  def test_add_a_lesson
    $ie.link(:text, (courses :draft).title).click
    $ie.link(:text, /Add a Lesson/).click
    $ie.text_field(:id, "content_title").set("a new lesson")
    $ie.text_field(:id, "content_teaser").set("the new lesson teaser")
    $ie.text_field(:id, "content_body").set("the new lesson body")
    $ie.form(:id, "new_lesson").submit
    assert $ie.h1(:text, "a new lesson").exist?
    assert $ie.p(:text, "the new lesson teaser").exist?
    assert $ie.div(:id, "content_body").text.include?("the new lesson body")
    $ie.link(:text, /Return to Course Overview/).click
    assert $ie.h2(:text, "a new lesson").exist?
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