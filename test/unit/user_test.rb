require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  should "require password" do
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

  should "create user" do
    assert_difference 'User.count' do
      user = new_valid_user
      assert user.save
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  should "reset password" do
    users(:duff).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:duff), communities(:c1).authenticate('duff', 'new password')
  end

  should "not rehash password" do
    users(:duff).update_attributes(:login => 'duff2')
    assert_equal users(:duff), communities(:c1).authenticate('duff2', 'test')
  end

  should "authenticate user" do
    assert_equal users(:duff), communities(:c1).authenticate('duff', 'test')
  end

  should "set remember token" do
    users(:duff).remember_me
    assert_not_nil users(:duff).remember_token
    assert_not_nil users(:duff).remember_token_expires_at
  end

  should "unset remember token" do
    users(:duff).remember_me
    assert_not_nil users(:duff).remember_token
    users(:duff).forget_me
    assert_nil users(:duff).remember_token
  end
  
  should "ensure owners are always active" do
    user = users(:duff)
    community = Community.new(:name => "Whatever", :subdomain => "whatever")
    user.community = community
    
    assert !user.active
    
    user.active = true
    assert user.active
    user.active = false
    assert !user.active

    community.owner = user
    assert user.active, "Owners should be active"
    
    user.active = false
    assert user.active, "Owners should be active"
  end
  
  should "display name" do
    user = User.new
    assert_nil(user.display_name)
    user.login = "Freddy"
    assert_equal("Freddy", user.display_name)
    user.display_name = "MySuper Display Name"
    assert_equal("MySuper Display Name", user.display_name)
  end
  
  

  private
    def new_valid_user(options = {})
      User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end

end
