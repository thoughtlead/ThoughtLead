require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionControllerTest < ActionController::TestCase
  context "SubscriptionController" do
    setup do
      ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.stubs(:unstore)
      ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.stubs(:store).returns(stub(:success? => true, :token => 'foo'))
      ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.stubs(:update).returns(stub(:success? => true, :token => 'foo'))
      ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.stubs(:purchase).returns(stub(:success? => true, :authorization => 'foo'))
    end

    context "on EDIT subscription" do
      setup do
        @user = User.make
        new_request(@user.community, @user)
        get :edit
      end

      should_assign_to :access_classes
      should_respond_with :success
      should_render_template :edit
      should_not_set_the_flash

      should "do nothing" do
      end
    end

    context "on UPDATE subscription to a paid subscription" do
      context "when the user is not the community owner" do
        setup do
          @user = User.make
          @access_class = AccessClass.make(:community => @user.community)
          @plan = SubscriptionPlan.make(:access_class => @access_class)

          new_request(@user.community, @user)
          put :update, {:subscription => {:subscription_plan_id => @plan.id}}
        end

        should_respond_with :redirect

        should "actually set the plan" do
          assert_equal @plan, @user.subscription.subscription_plan
        end
      end

      context "when the user is the community owner" do
        setup do
          @community = Community.make
          @user = @community.owner
          @access_class = AccessClass.make(:community => @community)
          @plan = SubscriptionPlan.make(:access_class => @access_class)

          new_request(@community, @user)
          put :update, {:subscription => {:subscription_plan_id => @plan.id}}
        end

        should_redirect_to "user_url(@user.id)"

        should "actually set the plan" do
          assert_equal @plan, @user.subscription.subscription_plan
        end
      end
    end

    context "on UPDATE subscription to free" do
      setup do
        @subscription = Subscription.make
        @user = @subscription.user

        assert_not_nil @user.access_class
        assert_not_nil @user.subscription
        new_request(@user.community, @user)
        put :update, {:subscription => {:subscription_plan_id => 'free'}}
      end

      should_respond_with :redirect

      should "actually set the user's access class to nil" do
        @user.reload
        assert_nil @user.subscription, "User should not have a subscription"
        assert_nil @user.access_class, "user should not have an access class if they choose the free plan"
      end
    end
  end
end
