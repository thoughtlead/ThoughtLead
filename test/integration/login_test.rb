require 'test_helper'

class LoginTest < ActionController::IntegrationTest
  fixtures :users


  def test_invalid_login
    login(:duff, "wrong_password")
    assert_flash("Invalid login or password.")
  end

  def test_valid_login
    login(:duff)
    
    assert_select("p", {:text => "Invalid email or password.", :count => 0 })
    assert_flash("Logged in successfully")
    assert_logged_in(:duff)    

    alex_session = new_session_as :alex
    assert_logged_in(:duff)    
    alex_session.assert_logged_in(:alex)
  end
  
  def test_unable_to_login_to_another_site
    new_session('c1') do
      assert(login(:duff))
      assert(login(:alex))
      assert(!login(:daniel))
    end
    
    new_session('c2') do
      assert(!login(:duff))
      assert(!login(:alex))
      assert(login(:daniel))
    end
  end
    
end