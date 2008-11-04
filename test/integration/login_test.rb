require File.dirname(__FILE__) + '/../test_helper' 

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
  
  def test_forgot_password_resets_correct_password
    donny1 = users :donnydupe1
    donny2 = users :donnydupe2
    donny1_password_before = donny1.crypted_password
    donny2_password_before = donny2.crypted_password
    post "http://c2.nokahuna.dev/forgot_password", :login => donny1.login
    donny1.reload
    donny2.reload
    assert_equal(donny1_password_before, donny1.crypted_password, "The wrong donny's password changed.")
    assert_not_equal(donny2_password_before, donny2.crypted_password, "The right donny's password didn't change.")
  end
  
  def test_unable_to_login_to_another_site
    new_session('c1.nokahuna.dev') do
      assert(login(:duff))
      assert(login(:alex))
      assert(!login(:daniel))
    end
    
    new_session('c2.nokahuna.dev') do
      assert(!login(:duff))
      assert(!login(:alex))
      assert(login(:daniel))
    end
  end
    
end