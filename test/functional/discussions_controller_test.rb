require File.dirname(__FILE__) + '/../test_helper'

class DiscussionsControllerTest < ActionController::TestCase
  def test_accessibility_rules_no_user
    #this is different than the unit tests because authenticated_system will do the proccess of setting current_user to :false
    unknown_user = nil
    public = discussions :its_coming
    premium = discussions :lost_my_monkey

    new_request(public.community,unknown_user)
    get :show, {:id=> public.id}
    assert_response :success
    new_request(premium.community,unknown_user)
    get :show, {:id=> premium.id}
    assert_response :redirect
  end

  def test_accessibility_rules_registered_user
    registered_user = users :duff
    public = discussions :its_coming
    premium = discussions :lost_my_monkey

    new_request(public.community,registered_user)
    get :show, {:id=> public.id}
    assert_response :success
    new_request(premium.community,registered_user)
    get :show, {:id=> premium.id}
    assert_response :success
  end

  def test_accessibility_premium_user
    premium_user = users :daniel
    public = discussions :its_coming
    premium = discussions :lost_my_monkey

    new_request(public.community,premium_user)
    get :show, {:id=> public.id}
    assert_response :success
    new_request(premium.community,premium_user)
    get :show, {:id=> premium.id}
    assert_response :success
  end

  def test_discussions_you_do_not_have_access_to_do_not_show_up_in_your_list_if_you_are_premium
    premium_user = users :premium_audrey
    public = discussions :c3_public_discussion

    new_request(public.community,premium_user)
    get :index

    assert_equal 4, assigns(:discussions).size
    assigns(:discussions).map(&:theme).each do |theme|
      assert theme.is_visible_to(premium_user)
    end
  end

  def test_discussions_you_do_not_have_access_to_do_not_show_up_in_your_list_if_you_are_ultrapremium
    premium_user = users :ultrapremium_audrey
    public = discussions :c3_public_discussion

    new_request(public.community,premium_user)
    get :index
    assert_equal 2, assigns(:discussions).size
    assigns(:discussions).map(&:theme).each do |theme|
      assert theme.is_visible_to(premium_user)
    end
  end

  def test_discussions_you_do_not_have_access_to_do_not_show_up_in_your_list_if_you_are_registered
    registered_user = users :audrey
    public = discussions :c3_public_discussion

    new_request(public.community,registered_user)
    get :index
    assert_equal 2, assigns(:discussions).size
    assigns(:discussions).map(&:theme).each do |theme|
      assert theme.is_visible_to(registered_user)
    end
  end

  def test_discussions_you_do_not_have_access_to_do_not_show_up_in_your_list_if_you_are_not_logged_in
    public = discussions :c3_public_discussion

    new_request(public.community)
    get :index
    assert_equal 1, assigns(:discussions).size
    assigns(:discussions).map(&:theme).each do |theme|
      assert theme.is_visible_to(nil)
    end
  end
end
