require File.dirname(__FILE__) + '/watir_setup'

class LoginTest < Test::Unit::TestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities
  
  def test_view_splash_page
    $ie.goto('http://localhost.com:3003/')
    assert_equal 'ThoughtLead', $ie.title
  end
  
  def test_view_community_page
    $ie.goto('http://testing.localhost.com:3003/')
    assert_equal 'Test', $ie.title
  end

  def test_log_in
    $ie.goto('http://testing.localhost.com:3003/')
    $ie.link(:text, "Login").click

    $ie.text_field(:id, "login").set("test")
    $ie.text_field(:id, "password").set("test")
    
    $ie.form(:action, "/sessions").submit
    
    assert_equal "Logged in successfully", $ie.div(:id, "flash").text
  end
  
end