require File.dirname(__FILE__) + '/../test_helper'

class LessonsControllerTest < ActionController::TestCase

  def test_accessibility_rules_no_user
    unknown_user = nil

    course = courses :happiness
    chapter = chapters :first_chapter

    public = lessons :public_lesson
    new_request(public.chapter.course.community, unknown_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    registered = lessons :registered_lesson
    new_request(registered.chapter.course.community, unknown_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect

    premium = lessons :premium_lesson
    new_request(premium.chapter.course.community, unknown_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect

    ultrapremium = lessons :ultrapremium_lesson
    new_request(ultrapremium.chapter.course.community, unknown_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
  end

  def test_accessibility_rules_registered_user
    registered_user = users :audrey
    course = courses :happiness
    chapter = chapters :first_chapter

    public = lessons :public_lesson
    new_request(registered_user.community,registered_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    registered = lessons :registered_lesson
    new_request(registered_user.community,registered_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    premium = lessons :premium_lesson
    new_request(registered_user.community,registered_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect

    ultrapremium = lessons :ultrapremium_lesson
    new_request(registered_user.community,registered_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
  end

  def test_accessibility_rules_ultrapremium_user
    ultrapremium_user = users :ultrapremium_audrey
    course = courses :happiness
    chapter = chapters :first_chapter

    public = lessons :public_lesson
    new_request(ultrapremium_user.community,ultrapremium_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    registered = lessons :registered_lesson
    new_request(ultrapremium_user.community,ultrapremium_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    premium = lessons :premium_lesson
    new_request(ultrapremium_user.community,ultrapremium_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect

    ultrapremium = lessons :ultrapremium_lesson
    new_request(ultrapremium_user.community, ultrapremium_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
  end

  def test_accessibility_premium_user
    premium_user = users :premium_audrey
    course = courses :happiness
    chapter = chapters :first_chapter

    public = lessons :public_lesson
    new_request(premium_user.community,premium_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    registered = lessons :registered_lesson
    new_request(premium_user.community,premium_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    premium = lessons :premium_lesson
    new_request(premium_user.community,premium_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    ultrapremium = lessons :ultrapremium_lesson
    new_request(premium_user.community, premium_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
  end
end
