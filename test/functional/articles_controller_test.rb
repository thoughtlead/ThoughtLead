require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def test_accessibility_rules_no_user
    unknown_user = nil

    public = articles :about_cats
    new_request(public.community,unknown_user)
    get :show, {:id=> public.id}
    assert_response :success

    registered = articles :about_registered
    new_request(registered.community,unknown_user)
    get :show, {:id=> registered.id}
    assert_response :redirect

    premium = articles :about_premium
    new_request(premium.community,unknown_user)
    get :show, {:id=> premium.id}
    assert_response :redirect

    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium.community,unknown_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :redirect
  end

  def test_accessibility_rules_registered_user
    registered_user = users :audrey

    public = articles :about_cats
    new_request(public.community,registered_user)
    get :show, {:id=> public.id}
    assert_response :success

    registered = articles :about_registered
    new_request(registered.community,registered_user)
    get :show, {:id=> registered.id}
    assert_response :success

    premium = articles :about_premium
    new_request(premium.community,registered_user)
    get :show, {:id=> premium.id}
    assert_response :redirect

    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium.community,registered_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :redirect
  end

  def test_accessibility_rules_ultrapremium_user
    ultrapremium_user = users :ultrapremium_audrey

    public = articles :about_cats
    new_request(public.community,ultrapremium_user)
    get :show, {:id=> public.id}
    assert_response :success

    registered = articles :about_registered
    new_request(registered.community,ultrapremium_user)
    get :show, {:id=> registered.id}
    assert_response :success

    premium = articles :about_premium
    new_request(premium.community,ultrapremium_user)
    get :show, {:id=> premium.id}
    assert_response :redirect

    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium.community,ultrapremium_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :success
  end

  def test_accessibility_premium_user
    premium_user = users :premium_audrey

    public = articles :about_cats
    new_request(public.community,premium_user)
    get :show, {:id=> public.id}
    assert_response :success

    registered = articles :about_registered
    new_request(registered.community,premium_user)
    get :show, {:id=> registered.id}
    assert_response :success

    premium = articles :about_premium
    new_request(premium.community,premium_user)
    get :show, {:id=> premium.id}
    assert_response :success

    ultrapremium = articles :about_ultrapremium
    new_request(ultrapremium.community,premium_user)
    get :show, {:id=> ultrapremium.id}
    assert_response :redirect
  end
end
