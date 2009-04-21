require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionControllerTest < ActionController::TestCase
  context "SubscriptionController" do
    setup do
      ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.stubs(:unstore)
      ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.stubs(:store).returns(stub(:success? => true, :token => 'foo'))
      ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.stubs(:update).returns(stub(:success? => true, :token => 'foo'))
    end

    context "on get UPGRADE when the community has no premium link and no payment gateway info" do
      setup do
        @community = Community.make(:premium_link => "", :gateway_login => "", :gateway_password => "")
        @user = User.make(:community => @community)
        @access_class = AccessClass.make(:community => @community)
        @subscription = Subscription.make(:user => @user)
        new_request(@user.community, @user)
        get :edit, :id => @subscription.id
      end

      should_respond_with :success
      should_render_template :edit

      should "not show any forms besides the search form" do
        assert_select "form", {:count => 1} do
          assert_select "[action=\"/search\"]"
        end
      end
    end

    context "on UPDATE subscription to a paid subscription" do
      context "when there is no free trial for the subscription plan" do
        setup do
          @user = User.make
          @user.subscription = Subscription.make

          @access_class = AccessClass.make(:community => @user.community)
          @plan = SubscriptionPlan.make(:access_class => @access_class, :trial_period => 0)
          ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.expects(:purchase).returns(stub(:success? => true, :authorization => 'foo'))

          new_request(@user.community, @user)
          put :update, {:subscription => {:subscription_plan_id => @plan.id}}
          @user.reload
        end

        should_redirect_to "user_url(@user.to_param)"

        should "set next renewal date to today plus renewal period" do
          assert_equal Date.today.advance({@plan.renewal_units => @plan.renewal_period}.symbolize_keys), @user.subscription.next_renewal_at, "should have moved today by #{@plan.renewal_period} #{@plan.renewal_units}"
        end

        should "actually set the plan" do
          assert_equal @plan, @user.subscription.subscription_plan
        end

        should "actually change the users access_class" do
          assert_equal @plan.access_class, @user.access_class
        end
      end


      context "when there is a free trial for the subscription plan" do
        context "and the member has not used their one free trial" do
          setup do
            ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.expects(:purchase).never
            @user = User.make(:trial_available => true)
            @user.subscription = Subscription.make
            assert @user.subscription.has_billing_information?
            @access_class = AccessClass.make(:community => @user.community)
            @plan = SubscriptionPlan.make(:access_class => @access_class, :trial_units => "weeks", :trial_period => 2)
            new_request(@user.community, @user)
            put :update, {:subscription => {:subscription_plan_id => @plan.id}}
            @user.reload
          end

          should_redirect_to "user_url(@user.to_param)"

          should "actually set the plan" do
            assert_equal @plan, @user.subscription.subscription_plan
          end

          should "set next renewal date to today plus trial period" do
            assert_equal Date.today.advance({@plan.trial_units => @plan.trial_period}.symbolize_keys), @user.subscription.next_renewal_at, "should have moved to today plus #{@plan.trial_period} #{@plan.trial_units}"
          end

          should "set trial_available to false" do
            assert !@user.trial_available
          end
        end

        context "but the member has already used their free trial" do
          setup do
            ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.expects(:purchase).returns(stub(:success? => true, :authorization => 'foo'))
            @user = User.make(:trial_available => false)
            @user.subscription = Subscription.make
            assert @user.subscription.has_billing_information?
            @access_class = AccessClass.make(:community => @user.community)
            @plan = SubscriptionPlan.make(:access_class => @access_class, :trial_units => "weeks", :trial_period => 2)
            new_request(@user.community, @user)
            put :update, {:subscription => {:subscription_plan_id => @plan.id}}
            @user.reload
          end

          should_redirect_to "user_url(@user.to_param)"

          should "actually set the plan" do
            assert_equal @plan, @user.subscription.subscription_plan
          end

          should "set next renewal date to today plus renewal period" do
            assert_equal Date.today.advance({@plan.renewal_units => @plan.renewal_period}.symbolize_keys), @user.subscription.next_renewal_at, "should have moved to today plus #{@plan.renewal_period} #{@plan.renewal_units}"
          end
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

        should_redirect_to "user_url(@user.to_param)"

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


    context "on get EDIT subscription" do
      setup do
        @user = User.make
        new_request(@user.community, @user)
        get :edit
      end

      should_assign_to :access_classes
      should_respond_with :success
      should_render_template :edit
      should_not_set_the_flash
    end
  end
end
