require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionControllerTest < ActionController::TestCase
  context "on EDIT subscription" do
    setup do
      user = users :audrey
      new_request(user.community, user)
      get :edit
    end

    should_assign_to :access_classes
    should_respond_with :success
    should_render_template :edit
    should_not_set_the_flash

    should "do nothing" do
#      user = users :test
#      assert_equal user.id, assigns(:user).id
    end
  end

  context "on UPDATE subscription to a paid subscription" do
    setup do
      plan = subscription_plans :c1_premium_monthly
      community = communities :c1
      sam = users :sam
      new_request(community, sam)
      post :update, {:subscription => {:subscription_plan_id => plan.id}}
    end

    should_respond_with :redirect

    should "actually set the plan" do
      plan = subscription_plans :c1_premium_monthly
      sam = users :sam
      assert_equal plan, sam.subscription.subscription_plan
    end
  end

  context "on UPDATE subscription to free" do
    setup do
      audrey = User.find(users(:premium_audrey).id)

      assert_not_nil audrey.access_class

      community = communities :c3
      new_request(community, audrey)
      post :update, {:subscription => {:subscription_plan_id => 'Free'}}
    end

    should_respond_with :redirect

    should "actually set the user's access class to nil" do
      audrey = User.find(users(:premium_audrey).id)
      assert audrey.access_class.nil?, "user should not have an access class if they choose the free plan"
    end
  end
end
