require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase
  context "CategoriesController" do
    setup do
      @community = Community.make
    end

    context "when sorting categories" do
      setup do
        @category1 = Category.make(:community => @community)
        @category2 = Category.make(:community => @community)

        @community.reload

        assert_equal(2, @community.categories.length)
        assert_equal(@category1, @community.categories.first)
        assert_equal(@category2, @community.categories.second)
      end

      should "handle sort correctly" do
        new_request(@community, @community.owner)

        xhr :post, :sort, { "categories" => [@category2.id, @category1.id] }

        @community.reload
        assert_equal(2, @community.categories.length)
        assert_equal(@category2, @community.categories.first)
        assert_equal(@category1, @community.categories.second)
      end
    end
  end
end