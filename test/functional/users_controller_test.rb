require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context "on GET to :show" do
    setup do
      @user = User.make
      new_request(@user.community, @user)
      get :show, :id => @user.to_param
    end

    should_assign_to :user
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash

    should "show the user that was requested" do
      assert_equal @user.id, assigns(:user).id
    end

  end

  context "when logged in as a premium member and trying to view the owners profile" do
    setup do
      @community = Community.make
      @owner = User.make(:community => @community)
      @community.owner = @owner
      @community.save
      @gold = AccessClass.make(:community => @community)
      @gold_user = User.make(:community => @community, :access_class => @gold)

      new_request(@gold_user.community, @gold_user)
      get :show, :id => @owner.to_param
    end

    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end

  context "on get SHOW your own profile when the community does not have a premium link or payment gateway information" do
    setup do
      @community = Community.make(:premium_link => "", :gateway_login => "", :gateway_password => "")
      @user = User.make(:community => @community)
      @subscription = Subscription.make(:user => @user)
      new_request(@user.community, @user)
      get :show, :id => @user.to_param
    end

    should_respond_with :success
    should_render_template :show

    should "not have a link to update payment informaiton" do
      assert_select "a" do
        assert_select "span", {:count => 0, :text => /Payment/ }, "there should not be a link to change payment information"
      end
    end
  end

  context "on get SHOW your own profile when the community does have a premium link but not a payment gateway information" do
    setup do
      @community = Community.make(:premium_link => "http://www.google.com", :gateway_login => "", :gateway_password => "")
      @user = User.make(:community => @community)
      @subscription = Subscription.make(:user => @user)
      new_request(@user.community, @user)
      get :show, :id => @user.to_param
    end

    should_respond_with :success
    should_render_template :show

    should "not have a link to update payment informaiton" do
      assert_select "a" do
        assert_select "span", {:count => 0, :text => /Payment/ }, "there should not be a link to change payment information"
      end
    end
  end

    context "on get SHOW your own profile when the community does not have a premium link but does have a payment gateway information" do
    setup do
      @community = Community.make(:premium_link => "", :gateway_login => "qwqewq", :gateway_password => "qwesdvs")
      @user = User.make(:community => @community)
      @subscription = Subscription.make(:user => @user)
      new_request(@user.community, @user)
      get :show, :id => @user.to_param
    end

    should_respond_with :success
    should_render_template :show

    should "have a link to update payment informaiton" do
      assert_select "span", {:count => 1, :text => /Payment/ }, "there should be a link to change payment information"
    end
  end
end
