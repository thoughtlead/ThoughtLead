require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  context "on GET to :show" do
    setup do
      @user = User.make
      new_request(@user.community, @user)
      get :show, :id => @user.id
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
      get :show, :id => @owner.id
    end

    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end
end
