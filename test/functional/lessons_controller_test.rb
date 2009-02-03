require File.dirname(__FILE__) + '/../test_helper'

class LessonsControllerTest < ActionController::TestCase
  context "LessonsController" do
    setup do
      @community = Community.make
      @gold = AccessClass.make(:community => @community)
      @silver = AccessClass.make(:community => @community)

      @registered_user = User.make(:community => @community)
      @gold_user = User.make(:community => @community, :access_class => @gold)
      @silver_user = User.make(:community => @community, :access_class => @silver)

      @course = Course.make(:community => @community)
      @chapter = Chapter.make(:course => @course)
    end

    context "with a public lesson" do
      setup do
        @lesson = Lesson.make(:chapter => @chapter)
      end

      should "allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end

      should "allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end

      should "allow access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end

      should "allow access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end
    end

    context "with a registered lesson" do
      setup do
        @content = Content.make(:user => @course.user, :registered => true)
        @lesson = Lesson.make(:chapter => @chapter, :content => @content)
      end

      should "not allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :redirect
      end

      should "allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end

      should "allow access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end

      should "allow access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end
    end

    context "with a gold lesson" do
      setup do
        @content = Content.make(:user => @course.user, :registered => true, :access_classes => [@gold])
        @lesson = Lesson.make(:chapter => @chapter, :content => @content)
      end

      should "not allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :redirect
      end

      should "not allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :redirect
      end

      should "allow access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end

      should "not access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :redirect
      end
    end

    context "with a silver lesson" do
      setup do
        @content = Content.make(:user => @course.user, :registered => true, :access_classes => [@silver])
        @lesson = Lesson.make(:chapter => @chapter, :content => @content)
      end

      should "not allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :redirect
      end

      should "not allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :redirect
      end

      should "not access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :redirect
      end

      should "allow access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @lesson.id, :chapter_id => @chapter.id, :course_id => @course.id }
        assert_response :success
      end
    end

    context "when sorting lessons" do
      setup do
        @lesson1 = Lesson.make(:chapter => @chapter)
        @lesson2 = Lesson.make(:chapter => @chapter)
        @chapter.reload
        assert_equal(2, @chapter.lessons.length)
        assert_equal(@lesson1, @chapter.lessons.first)
        assert_equal(@lesson2, @chapter.lessons.second)
      end

      should "handle sort correctly" do
        new_request(@community, @community.owner)

        xhr :post, :sort, { :chapter_id => @chapter.id, "chapter_#{@chapter.id}" => [@lesson2.id, @lesson1.id] }

        @chapter.reload
        assert_equal(2, @chapter.lessons.length)
        assert_equal(@lesson2, @chapter.lessons.first)
        assert_equal(@lesson1, @chapter.lessons.second)
      end
    end
  end
end
