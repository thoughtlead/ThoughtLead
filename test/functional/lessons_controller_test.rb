require File.dirname(__FILE__) + '/../test_helper' 

class LessonsControllerTest < ActionController::TestCase
  
  def test_accessibility_rules_no_user
    unknown_user = nil
    
    course = courses :happiness
    chapter = chapters :first_chapter
    
    public = lessons :public_lesson
    new_request(public,unknown_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
    
    registered = lessons :registered_lesson
    new_request(registered,unknown_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
    
    premium = lessons :premium_lesson
    new_request(premium,unknown_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
    
    ultrapremium = lessons :ultrapremium_lesson
    new_request(ultrapremium,unknown_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
  end
    
  def test_accessibility_rules_registered_user
    registered_user = users :audrey
    course = courses :happiness
    chapter = chapters :first_chapter
    
    public = lessons :public_lesson
    new_request(public,registered_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
    
    registered = lessons :registered_lesson
    new_request(registered,registered_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
    
    premium = lessons :premium_lesson
    new_request(premium,registered_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
    
    ultrapremium = lessons :ultrapremium_lesson
    new_request(ultrapremium,registered_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
  end
  
  def test_accessibility_rules_ultrapremium_user
    ultrapremium_user = users :ultrapremium_audrey
    course = courses :happiness
    chapter = chapters :first_chapter
    
    public = lessons :public_lesson
    new_request(public,ultrapremium_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    registered = lessons :registered_lesson
    new_request(registered,ultrapremium_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
    
    premium = lessons :premium_lesson
    new_request(premium,ultrapremium_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
    
    ultrapremium = lessons :ultrapremium_lesson
    new_request(ultrapremium,ultrapremium_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
  end
    
  def test_accessibility_premium_user
    premium_user = users :premium_audrey
    course = courses :happiness
    chapter = chapters :first_chapter
        
    public = lessons :public_lesson
    new_request(public,premium_user)
    get :show, {:id=> public.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success

    registered = lessons :registered_lesson
    new_request(registered,premium_user)
    get :show, {:id=> registered.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
    
    premium = lessons :premium_lesson
    new_request(premium,premium_user)
    get :show, {:id=> premium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :success
    
    ultrapremium = lessons :ultrapremium_lesson
    new_request(ultrapremium,premium_user)
    get :show, {:id=> ultrapremium.id, :course_id => course.id, :chapter_id => chapter.id}
    assert_response :redirect
  end
  
  def new_request(lesson,user=nil)
    raise "The user isn't a User object" if user && user.class != User
    @request = ActionController::TestRequest.new
    course = courses :happiness
    chapter = chapters :first_chapter
    @request.host = lesson.chapter.course.community.host
    @request.session[:user_id] = user.nil? ? nil : user.id
  end
end