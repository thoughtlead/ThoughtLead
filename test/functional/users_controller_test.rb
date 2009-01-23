require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context "on GET to :show" do
    setup do
      @user = User.make
      new_request(@user.community, @user)
      get :show, :id => @user.id
    end

    should_assign_to :user
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash

    should "show the user that was requested" do
      assert_equal @user.id, assigns(:user).id
    end
  end
end
