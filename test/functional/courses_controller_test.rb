require File.dirname(__FILE__) + '/../test_helper'

class CoursesControllerTest < ActionController::TestCase
  context "CoursesController" do
    setup do
      @community = Community.make
    end

    context "when sorting courses" do
      setup do
        @course1 = Course.make(:community => @community)
        @course2 = Course.make(:community => @community)

        @community.reload

        assert_equal(2, @community.courses.length)
        assert_equal(@course1, @community.courses.first)
        assert_equal(@course2, @community.courses.second)
      end

      should "handle sort correctly" do
        new_request(@community, @community.owner)

        xhr :post, :sort, { "courses" => [@course2.id, @course1.id] }

        @community.reload
        assert_equal(2, @community.courses.length)
        assert_equal(@course2, @community.courses.first)
        assert_equal(@course1, @community.courses.second)
      end
    end
  end
end