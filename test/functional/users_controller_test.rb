require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  def test_can_access_own_profile
    registered_user = users :audrey

    new_request(registered_user, registered_user)
    get :show, {:id => registered_user.id}
    assert_response :success
  end

  def new_request(requested_user, user = nil)
    raise "The user isn't a User object" if user && user.class != User
    @request = ActionController::TestRequest.new
    @request.host = requested_user.community.host
    @request.session[:user_id] = user.nil? ? nil : user.id
  end
end