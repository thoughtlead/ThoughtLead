require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  def test_password_required
    user = new_valid_user(:login => 'my_login', :email => 'me@example.com')
    assert(user.send(:password_required?))
    
    user.password = "wow"
    user.password_confirmation = "wow"
    assert(user.save)
    
    user = User.find(user.id)
    assert(!user.send(:password_required?))
    
    user.password_required = true
    assert(user.send(:password_required?))

    user = User.find(user.id)
    user.password = "   "
    assert(!user.send(:password_required?))
    user.password_confirmation = "  "
    assert(!user.send(:password_required?))
    
    user.password = "Something"
    assert(user.send(:password_required?))

    user = User.find(user.id)
    assert(!user.send(:password_required?))

    user.password_confirmation = "Something"
    assert(user.send(:password_required?))
  end

  def test_should_create_user
    assert_difference 'User.count' do
      user = new_valid_user
      assert user.save
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_reset_password
    users(:duff).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:duff), User.authenticate('duff', 'new password')
  end

  def test_should_not_rehash_password
    users(:duff).update_attributes(:login => 'duff2')
    assert_equal users(:duff), User.authenticate('duff2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:duff), User.authenticate('duff', 'test')
  end

  def test_should_set_remember_token
    users(:duff).remember_me
    assert_not_nil users(:duff).remember_token
    assert_not_nil users(:duff).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:duff).remember_me
    assert_not_nil users(:duff).remember_token
    users(:duff).forget_me
    assert_nil users(:duff).remember_token
  end

  private
    def new_valid_user(options = {})
      User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end

end