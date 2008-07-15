require File.dirname(__FILE__) + '/watir_test_case'

class LoginTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities
  
  def test_view_splash_page
    $ie.goto($BASE_URL)
    assert_equal 'ThoughtLead', $ie.title
  end
  
  def test_view_community_page
    $ie.goto($COMMUNITY_URL)
    assert_equal 'Test', $ie.title
  end
  
  def test_log_in
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    
    #check and make sure there are forgot password and sign-up links
    assert $ie.link(:text,"Forgot Password?").exist?
    assert $ie.link(:text,"Create a New Account").exist?
    
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")
    
    $ie.form(:action, "/sessions").submit
    
    assert_equal "Logged in successfully", $ie.div(:id, "flash").text
  end
  
end