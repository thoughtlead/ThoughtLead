require File.dirname(__FILE__) + '/../test_helper'

class ThemeTest < ActiveSupport::TestCase
  context "A Theme" do
    setup do
      @community = Community.make
      @theme = Theme.new(:community => @community)
      @user = User.make(:community => @community)
    end

    context "that doesn't require registered users" do
      setup do
        @theme.registered = false
      end

      should "be visible to nil users" do
        assert_equal(true, @theme.is_visible_to(nil))
      end

      should "be visible to registered users" do
        assert_equal(true, @theme.is_visible_to(@user))
      end

      should "be visible to the community owner" do
        assert_equal(true, @theme.is_visible_to(@community.owner))
      end
    end

    context "that requires registered users" do
      setup do
        @theme.registered = true
      end

      context "with no access classes" do
        should "not be visible to nil users" do
          assert_equal(false, @theme.is_visible_to(nil))
        end

        should "be visible to registered users" do
          assert_equal(true, @theme.is_visible_to(@user))
        end

        should "be visible to the community owner" do
          assert_equal(true, @theme.is_visible_to(@community.owner))
        end
      end

      context "with required access class" do
        setup do
          @access_class = AccessClass.make(:community => @community)
          @theme.access_classes << @access_class
          @user_with_access = User.make(:community => @community, :access_class => @access_class)
        end

        should "not be visible to nil users" do
          assert_equal(false, @theme.is_visible_to(nil))
        end

        should "not be visible to registered users" do
          assert_equal(false, @theme.is_visible_to(@user))
        end

        should "be visible to users with the right access" do
          assert_equal(true, @theme.is_visible_to(@user_with_access))
        end

        should "be visible to the community owner" do
          assert_equal(true, @theme.is_visible_to(@community.owner))
        end
      end
    end
  end
end