require File.dirname(__FILE__) + '/watir_test_case'

class ProfilePageTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities
  
#  def test_work_to_do
#    assert false
#  end
  
  def test_disabled_user_display
    $ie.link(:text, (users :disabled).login).click
    h1 = $ie.h1(:text, /#{(users :disabled).to_s}/)
    #puts "\n" + li.html + "\n"
    assert !h1.locate_tagged_element("strike",:text,(users :disabled).to_s).nil?
  end
  
  def test_expert_user_display
    $ie.link(:text, (users :expert).login).click
    h1 = $ie.h1(:text, /#{(users :expert).to_s}/)
    #puts "\n" + li.html + "\n"
    assert h1.image(:src, /star/).exist?    
  end

  def test_edit_profile_accessibility
    $ie.link(:text, (users :expert).login).click
    assert $ie.link(:text, "Edit Profile").exist?    
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :expert).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "People").click
    $ie.link(:text, (users :expert).login).click
    assert $ie.link(:text, "Edit Profile").exist?    
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "People").click
    $ie.link(:text, (users :expert).login).click
    assert !$ie.link(:text, "Edit Profile").exist?    
  end

  def test_disable_inaccessible_to_nonadmin
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "People").click
    $ie.link(:text, (users :registered).login).click
    assert !$ie.link(:text, "Disable this User").exist?
  end
  
  private
  
  def setup
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "People").click
  end
  
end