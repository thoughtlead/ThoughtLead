require File.dirname(__FILE__) + '/watir_test_case'

class DiscussionsTabTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities, :discussions, :themes

#  def test_work_to_do
#    assert false
#  end
  
  def test_add_a_discussion_topic
    $ie.link(:text, /Add a Discussion Topic/).click
    $ie.text_field(:id, "discussion_title").set("a new discussion")
    $ie.text_field(:id, "discussion_body").set("the new discussion body")
    $ie.form(:id, "new_discussion").submit
    assert $ie.h1(:text, "a new discussion").exist?
    assert $ie.p(:text, "the new discussion body").exist?
    $ie.link(:text, /Return to Discussions/).click
    assert $ie.link(:text, "a new discussion").exist?
  end
  
  def test_edit_themes
    $ie.link(:text, "Edit Themes").click
    
    $ie.text_field(:id, "theme_name").set("a new theme")
    $ie.text_field(:id, "theme_description").set("the new theme description")
    $ie.form(:id, "new_theme").submit
    li = $ie.li(:text, /a new theme/)
    #puts "\n\n" + li.text + "\n\n"
    
    li.link(:text,"Edit").click
    $ie.text_field(:id, "theme_name").set("an edited theme")
    $ie.text_field(:id, "theme_description").set("the edited theme description")
    $ie.form(:id, /edit_theme/).submit

    assert !($ie.li(:text, /a new theme/).exist?)
    li = $ie.li(:text, /an edited theme/)
    #puts "\n\n" + li.text + "\n\n"

    li.link(:text,"Delete").click
    assert !($ie.li(:text, /an edited theme/).exist?)
  end

  def test_select_theme
    #full
    assert $ie.link(:text, (discussions :theme_none_discussion_1).title).exist?
    assert $ie.link(:text, (discussions :theme_1_discussion_1).title).exist?
    assert $ie.link(:text, (discussions :theme_2_discussion_1).title).exist?
    #cat 1
    $ie.link(:text, (themes :theme_1).name).click
    assert !($ie.link(:text, (discussions :theme_none_discussion_1).title).exist?)
    assert $ie.link(:text, (discussions :theme_1_discussion_1).title).exist?
    assert !($ie.link(:text, (discussions :theme_2_discussion_1).title).exist?)
    #cat 2
    $ie.link(:text, (themes :theme_2).name).click
    assert !($ie.link(:text, (discussions :theme_none_discussion_1).title).exist?)
    assert !($ie.link(:text, (discussions :theme_1_discussion_1).title).exist?)
    assert $ie.link(:text, (discussions :theme_2_discussion_1).title).exist?
    #general
    $ie.link(:text, "General").click
    assert $ie.link(:text, (discussions :theme_none_discussion_1).title).exist?
    assert !($ie.link(:text, (discussions :theme_1_discussion_1).title).exist?)
    assert !($ie.link(:text, (discussions :theme_2_discussion_1).title).exist?)
    #full
    $ie.link(:text, "All Discussions").click
    assert $ie.link(:text, (discussions :theme_none_discussion_1).title).exist?
    assert $ie.link(:text, (discussions :theme_1_discussion_1).title).exist?
    assert $ie.link(:text, (discussions :theme_2_discussion_1).title).exist?
  end
  
  def test_user_links
    link = $ie.link(:text, (users :expert).login)
    assert link.image(:src, /star/).exist?
    link.click
    assert $ie.h1(:text, /#{(users :expert).login}/).exist?
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Discussions").click
    2.times do $ie.link(:text, (users :disabled).login).click end #It doesn't seem to click it once unless you tell it to click it twice???
    $ie.wait #and why does it need a wait here???
    assert_equal "The user \"#{(users :disabled).login}\" has been disabled.", $ie.div(:id, "flash").text
  end

#  def test_theme_visibility
#    assert !($ie.link(:text,(themes :empty).name).exist?)
#    $ie.link(:text,"Edit Categories").click
#    assert $ie.li(:text, /#{(themes :empty).name}/).exist?
#  end
  

  private
  
  def setup
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Discussions").click
  end
  
end