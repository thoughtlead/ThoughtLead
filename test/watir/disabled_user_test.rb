require File.dirname(__FILE__) + '/watir_test_case'

class DisabledUserTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities
  
  def test_disabled_status_can_be_set_unset_and_works
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    
    # Try to log in as disabled dude
    $ie.text_field(:id, "login").set((users :disabled).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    # ... and fail
    assert_equal "Invalid login or password.", $ie.div(:id, "flash").text
    
    # Now log in as owner
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    # ... and reactivate dude
    $ie.link(:text, "People").click
    $ie.link(:text, (users :disabled).login).click
    assert !$ie.link(:text, "Disable this User").exist?
    $ie.link(:text, "Reactivate this User").click
    assert $ie.link(:text, "Disable this User").exist?
    $ie.link(:text, "Logout").click
    
    #Try again as now un-disabled dude
    $ie.text_field(:id, "login").set((users :disabled).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    # ... and succeed
    assert_equal "Logged in successfully", $ie.div(:id, "flash").text
    $ie.link(:text, "Logout").click    
    
    # Now log in as owner
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    # ... and redisable dude
    $ie.link(:text, "People").click
    $ie.link(:text, (users :disabled).login ).click
    assert !$ie.link(:text, "Reactivate this User").exist?
    $ie.link(:text, "Disable this User").click
    assert $ie.link(:text, "Reactivate this User").exist?
    $ie.link(:text, "Logout").click
    
    # Try to log in as disabled dude
    $ie.text_field(:id, "login").set( (users :disabled).login )
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    # ... and fail
    assert_equal "Invalid login or password.", $ie.div(:id, "flash").text
  end
  
end