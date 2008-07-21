require File.dirname(__FILE__) + '/watir_test_case'

class AccessRightsTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :courses, :communities, :lessons, :chapters, :contents, :articles

#  def test_work_to_do
#    assert false
#  end
    
  def test_lesson_access_rights
    $ie.text_field(:id, "login").set((users :watir_premium).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Courses").click    

    $ie.link(:text, (courses :tagged).title).click
    $ie.link(:text, (contents :tagged_1_premium).title).click
    $ie.link(:text, /Return to Course Overview/).click
    $ie.link(:text, (contents :tagged_1_registered).title).click
    $ie.link(:text, /Return to Course Overview/).click
    $ie.link(:text, (contents :tagged_1_public).title).click

    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :registered).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Courses").click    

    $ie.link(:text, (courses :tagged).title).click
    $ie.link(:text, (contents :tagged_1_premium).title).click
    assert $ie.url.include?("upgrade")
    $ie.link(:text, "Courses").click        
    $ie.link(:text, (courses :tagged).title).click
    $ie.link(:text, (contents :tagged_1_registered).title).click
    $ie.link(:text, /Return to Course Overview/).click
    $ie.link(:text, (contents :tagged_1_public).title).click

    $ie.link(:text, "Logout").click
    $ie.link(:text, "Courses").click    

    $ie.link(:text, (courses :tagged).title).click
    $ie.link(:text, (contents :tagged_1_premium).title).click
    assert $ie.url.include?("login")
    $ie.link(:text, "Courses").click        
    $ie.link(:text, (courses :tagged).title).click
    $ie.link(:text, (contents :tagged_1_registered).title).click
    assert $ie.url.include?("login")
    $ie.link(:text, "Courses").click        
    $ie.link(:text, (courses :tagged).title).click
    $ie.link(:text, (contents :tagged_1_public).title).click
  end
  
  def test_article_access_rights
    $ie.text_field(:id, "login").set((users :watir_premium).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.goto($COMMUNITY_URL + "library")

    $ie.link(:text, (contents :premium).title).click
    $ie.link(:text, /Return to Library/).click
    $ie.link(:text, (contents :registered).title).click
    $ie.link(:text, /Return to Library/).click
    $ie.link(:text, (contents :public).title).click

    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :registered).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.goto($COMMUNITY_URL + "library")

    $ie.link(:text, (contents :premium).title).click
    assert $ie.url.include?("upgrade")
    $ie.goto($COMMUNITY_URL + "library")
    $ie.link(:text, (contents :registered).title).click
    $ie.link(:text, /Return to Library/).click
    $ie.link(:text, (contents :public).title).click

    $ie.link(:text, "Logout").click
    $ie.goto($COMMUNITY_URL + "library")

    $ie.link(:text, (contents :premium).title).click
    assert $ie.url.include?("login")
    $ie.goto($COMMUNITY_URL + "library")
    $ie.link(:text, (contents :registered).title).click
    assert $ie.url.include?("login")
    $ie.goto($COMMUNITY_URL + "library")
    $ie.link(:text, (contents :public).title).click
  end

  private
  
  def setup
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
  end
  
end