require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_can_access_own_profile
    registered_user = users :audrey

    new_request(registered_user.community, registered_user)
    get :show, {:id => registered_user.id}
    assert_response :success
  end

  context "on GET to :show for first record" do
    setup do
      user = users :test
      new_request(user.community, user)
      get :show, :id => user.id
    end

    should_assign_to :user
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash

    should "show the user that was requested" do
      user = users :test
      assert_equal user.id, assigns(:user).id
    end
  end
end
