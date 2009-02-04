require File.dirname(__FILE__) + '/../test_helper'

class AccessClassTest < ActiveSupport::TestCase
  context "An AccessClass" do
    setup do
      @community = Community.make
      @access_class = AccessClass.make(:community => @community)

      @grandchild = AccessClass.make(:community => @community)
      @child = AccessClass.make(:community => @community, :children => [@grandchild])
      @parent = AccessClass.make(:community => @community, :children => [@child])
    end

    should "have access to an empty list of access classes" do
      assert_equal true, @access_class.has_access_to([])
    end

    should "have access to itself" do
      assert_equal true, @access_class.has_access_to(@access_class)
    end

    should "work whether access class is specified as a array or by itself" do
      assert_equal true, @access_class.has_access_to(@access_class)
      assert_equal true, @access_class.has_access_to([@access_class])
    end

    should "have access to its child access classes" do
      assert_equal true, @parent.has_access_to(@child)
      assert_equal true, @child.has_access_to(@grandchild)
    end

    should "not have access to its grandchild access classes" do
      assert_equal false, @parent.has_access_to(@grandchild)
    end

    should "not have access to its parent access classes" do
      assert_equal false, @child.has_access_to(@parent)
    end

    should "not have access to unrelated access classes" do
      assert_equal false, @parent.has_access_to(@access_class)
      assert_equal false, @child.has_access_to(@access_class)
    end
  end
end