require File.dirname(__FILE__) + '/watir_test_case'

class CreateUserTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities
  
  def test_can_create_new_user_and_access_profile
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Signup").click
    
    #create new user
    $ie.text_field(:id, "user_login").set("new")
    $ie.text_field(:id, "user_email").set("new@dot.dot")    
    $ie.text_field(:id, "user_password").set("test")    
    $ie.text_field(:id, "user_password_confirmation").set("test")    
    $ie.form(:action, /signup/).submit
    
    #go to profile
    $ie.link(:text, "People").click
    $ie.link(:text, "new").click
    assert $ie.h1(:text, /new/).exist?    
  end
  
end