require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  context "A User" do
    setup do
      @community = Community.make
      @user = User.make(:community => @community)
    end

    should "require password" do
      user = User.make_unsaved(:community => @community)
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
        user = User.make(:community => @community)
        assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
      end
    end

    should "reset password" do
      @user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      assert_equal @user, @community.authenticate(@user.login, 'new password')
    end

    should "not rehash password" do
      @user.update_attributes(:login => 'duff2')
      assert_equal @user, @community.authenticate('duff2', @user.password)
    end

    should "authenticate user" do
      assert_equal @user, @community.authenticate(@user.login, @user.password)
    end

    should "set remember token" do
      @user.remember_me
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
    end

    should "unset remember token" do
      @user.remember_me
      assert_not_nil @user.remember_token
      @user.forget_me
      assert_nil @user.remember_token
    end

    should "ensure owners are always premium members" do
      user = @user
      community = Community.make
      user.community = community
      AccessClass.make(:community => community)

      assert_nil user.access_class

      community.owner = user
      assert_not_nil user.access_class, "Owners should be premium members"

      user.access_class = nil
      assert_not_nil user.access_class, "Owners should be premium members"
    end

    should "have the correct name displayed" do
      user = User.new
      assert_nil(user.display_name)
      user.login = "Freddy"
      assert_equal("Freddy", user.to_s)
      user.display_name = "MySuper Display Name"
      assert_equal("MySuper Display Name", user.to_s)
    end
  end

end
