require File.dirname(__FILE__) + '/../test_helper'

class ThemesControllerTest < ActionController::TestCase
  context "ThemesController" do
    setup do
      @community = Community.make
    end

    context "when sorting themes" do
      setup do
        @theme1 = Theme.make(:community => @community)
        @theme2 = Theme.make(:community => @community)

        @community.reload

        assert_equal(2, @community.themes.length)
        assert_equal(@theme1, @community.themes.first)
        assert_equal(@theme2, @community.themes.second)
      end

      should "handle sort correctly" do
        new_request(@community, @community.owner)

        xhr :post, :sort, { "themes" => [@theme2.id, @theme1.id] }

        @community.reload
        assert_equal(2, @community.themes.length)
        assert_equal(@theme2, @community.themes.first)
        assert_equal(@theme1, @community.themes.second)
      end
    end
  end
end