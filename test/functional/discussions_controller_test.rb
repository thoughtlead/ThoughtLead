require File.dirname(__FILE__) + '/../test_helper' 

class DiscussionsControllerTest < ActionController::TestCase
  def test_accessibility_rules_no_user
    #this is different than the unit tests because authenticated_system will do the proccess of setting current_user to :false
    unknown_user = nil
    public = discussions :its_coming
    premium = discussions :lost_my_monkey

    new_request(public,unknown_user)
    get :show, {:id=> public.id}
    assert_response :success
    new_request(premium,unknown_user)
    get :show, {:id=> premium.id}
    assert_response :redirect
  end
    
  def test_accessibility_rules_registered_user
    registered_user = users :duff
    public = discussions :its_coming
    premium = discussions :lost_my_monkey

    new_request(public,registered_user)
    get :show, {:id=> public.id}
    assert_response :success
    new_request(premium,registered_user)
    get :show, {:id=> premium.id}
    assert_response :success
  end
    
  def test_accessibility_premium_user
    premium_user = users :daniel
    public = discussions :its_coming
    premium = discussions :lost_my_monkey

    new_request(public,premium_user)
    get :show, {:id=> public.id}
    assert_response :success
    new_request(premium,premium_user)
    get :show, {:id=> premium.id}
    assert_response :success
  end

  def new_request(discussion,user=nil)
    raise "The user isn't a User object" if user && user.class != User
    @request = ActionController::TestRequest.new
    @request.host = discussion.community.host
    @request.session[:user] = user.nil? ? nil : user.id
  end
end