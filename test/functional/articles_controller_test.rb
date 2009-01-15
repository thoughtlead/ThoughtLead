require File.dirname(__FILE__) + '/../test_helper' 

class ArticlesControllerTest < ActionController::TestCase
  def test_accessibility_rules_no_user
    unknown_user = nil
    
    public = articles :about_cats
    new_request(public,unknown_user)
    get :show, {:id=> public.id}
    assert_response :success
    
    registered = articles :about_registered
    new_request(registered,unknown_user)
    get :show, {:id=> registered.id}
    assert_response :redirect
    
    premium = articles :about_premium
    new_request(premium,unknown_user)
    get :show, {:id=> premium.id}
    assert_response :redirect
    
    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium,unknown_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :redirect
  end
    
  def test_accessibility_rules_registered_user
    registered_user = users :audrey
    
    public = articles :about_cats
    new_request(public,registered_user)
    get :show, {:id=> public.id}
    assert_response :success
    
    registered = articles :about_registered
    new_request(registered,registered_user)
    get :show, {:id=> registered.id}
    assert_response :success
    
    premium = articles :about_premium
    new_request(premium,registered_user)
    get :show, {:id=> premium.id}
    assert_response :redirect
    
    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium,registered_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :redirect
  end
  
  def test_accessibility_rules_ultrapremium_user
    ultrapremium_user = users :ultrapremium_audrey

    public = articles :about_cats
    new_request(public,ultrapremium_user)
    get :show, {:id=> public.id}
    assert_response :success

    registered = articles :about_registered
    new_request(registered,ultrapremium_user)
    get :show, {:id=> registered.id}
    assert_response :success
    
    premium = articles :about_premium
    new_request(premium,ultrapremium_user)
    get :show, {:id=> premium.id}
    assert_response :redirect
    
    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium,ultrapremium_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :success
  end
    
  def test_accessibility_premium_user
    premium_user = users :premium_audrey
    
    public = articles :about_cats
    new_request(public,premium_user)
    get :show, {:id=> public.id}
    assert_response :success

    registered = articles :about_registered
    new_request(registered,premium_user)
    get :show, {:id=> registered.id}
    assert_response :success
    
    premium = articles :about_premium
    new_request(premium,premium_user)
    get :show, {:id=> premium.id}
    assert_response :success
    
    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium,premium_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :redirect
  end
  
  def new_request(article,user=nil)
    raise "The user isn't a User object" if user && user.class != User
    @request = ActionController::TestRequest.new
    @request.host = article.community.host
    @request.session[:user_id] = user.nil? ? nil : user.id
  end
end