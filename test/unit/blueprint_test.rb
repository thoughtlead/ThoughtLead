require File.dirname(__FILE__) + '/../test_helper'

class BlueprintTest < ActiveSupport::TestCase
  context "Blueprint" do
    should "make AccessClass" do
      assert AccessClass.make
    end

    should "make Article" do
      assert Article.make
    end

    should "make Chapter" do
      assert Chapter.make
    end

    should "make Community" do
      assert Community.make
    end

    should "make Content" do
      assert Content.make
    end

    should "make Course" do
      assert Course.make
    end

    should "make Discussion" do
      assert Discussion.make
    end

    should "make Lesson" do
      assert Lesson.make
    end

    should "make Subscription" do
      assert Subscription.make
    end

    should "make SubscriptionPlan" do
      assert SubscriptionPlan.make
    end

    should "make Theme" do
      assert Theme.make
    end

    should "make User" do
      assert User.make
    end
  end
end