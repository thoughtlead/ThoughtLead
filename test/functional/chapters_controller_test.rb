require File.dirname(__FILE__) + '/../test_helper'

class ChaptersControllerTest < ActionController::TestCase
  context "ChaptersController" do
    setup do
      @community = Community.make
      @course = Course.make(:community => @community)
    end

    context "when sorting chapters" do
      setup do
        @chapter1 = Chapter.make(:course => @course)
        @chapter2 = Chapter.make(:course => @course)
        @course.reload
        assert_equal(2, @course.chapters.length)
        assert_equal(@chapter1, @course.chapters.first)
        assert_equal(@chapter2, @course.chapters.second)
      end

      should "handle sort correctly" do
        new_request(@community, @community.owner)

        xhr :post, :sort, { :course_id => @course.id, "chapters" => [@chapter2.id, @chapter1.id] }

        @course.reload
        assert_equal(2, @course.chapters.length)
        assert_equal(@chapter2, @course.chapters.first)
        assert_equal(@chapter1, @course.chapters.second)
      end
    end
  end
end