require File.dirname(__FILE__) + '/../test_helper'

class DiscussionsControllerTest < ActionController::TestCase
  context "DiscussionsController" do
    setup do
      @community = Community.make
      @gold = AccessClass.make(:community => @community)
      @silver = AccessClass.make(:community => @community)

      @registered_user = User.make(:community => @community)
      @gold_user = User.make(:community => @community, :access_class => @gold)
      @silver_user = User.make(:community => @community, :access_class => @silver)
    end

    context "on GET to :show" do
      context "with a public discussion" do
        setup do
          @discussion = Discussion.make(:community => @community)
        end

        should "allow access to public" do
          new_request(@community, nil)
          get :show, { :id => @discussion.id }
          assert_response :success
        end

        should "allow access to registered user" do
          new_request(@community, @registered_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end

        should "allow access to gold user" do
          new_request(@community, @gold_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end

        should "allow access to silver user" do
          new_request(@community, @silver_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end
      end

      context "with a registered discussion" do
        setup do
          @theme = Theme.make(:community => @community, :registered => true)
          @discussion = Discussion.make(:community => @community, :theme => @theme)
        end

        should "not allow access to public" do
          new_request(@community, nil)
          get :show, { :id => @discussion.id }
          assert_response :redirect
        end

        should "allow access to registered user" do
          new_request(@community, @registered_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end

        should "allow access to gold user" do
          new_request(@community, @gold_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end

        should "allow access to silver user" do
          new_request(@community, @silver_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end
      end

      context "with a gold discussion" do
        setup do
          @theme = Theme.make(:community => @community, :registered => true, :access_classes => [@gold])
          @discussion = Discussion.make(:community => @community, :theme => @theme)
        end

        should "not allow access to public" do
          new_request(@community, nil)
          get :show, { :id => @discussion.id }
          assert_response :redirect
        end

        should "not allow access to registered user" do
          new_request(@community, @registered_user)
          get :show, { :id => @discussion.id }
          assert_response :redirect
        end

        should "allow access to gold user" do
          new_request(@community, @gold_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end

        should "not access to silver user" do
          new_request(@community, @silver_user)
          get :show, { :id => @discussion.id }
          assert_response :redirect
        end
      end

      context "with a silver discussion" do
        setup do
          @theme = Theme.make(:community => @community, :registered => true, :access_classes => [@silver])
          @discussion = Discussion.make(:community => @community, :theme => @theme)
        end

        should "not allow access to public" do
          new_request(@community, nil)
          get :show, { :id => @discussion.id }
          assert_response :redirect
        end

        should "not allow access to registered user" do
          new_request(@community, @registered_user)
          get :show, { :id => @discussion.id }
          assert_response :redirect
        end

        should "not access to gold user" do
          new_request(@community, @gold_user)
          get :show, { :id => @discussion.id }
          assert_response :redirect
        end

        should "allow access to silver user" do
          new_request(@community, @silver_user)
          get :show, { :id => @discussion.id }
          assert_response :success
        end
      end
    end

    context "on GET to :index" do
      setup do
        @public_discussion = Discussion.make(:community => @community)

        @registered_theme = Theme.make(:community => @community, :registered => true)
        @registered_discussion = Discussion.make(:community => @community, :theme => @registered_theme)

        @gold_theme = Theme.make(:community => @community, :registered => true, :access_classes => [@gold])
        @gold_discussion = Discussion.make(:community => @community, :theme => @gold_theme)

        @silver_theme = Theme.make(:community => @community, :registered => true, :access_classes => [@silver])
        @silver_discussion = Discussion.make(:community => @community, :theme => @silver_theme)
      end

      context "when not logged in" do
        setup do
          new_request(@community, nil)
          get :index
        end

        should "see public discussion" do
          assert_equal(true, assigns(:discussions).include?(@public_discussion))
        end
        should "not see registered discussion" do
          assert_equal(false, assigns(:discussions).include?(@registered_discussion))
        end
        should "not see gold discussion" do
          assert_equal(false, assigns(:discussions).include?(@gold_discussion))
        end
        should "not see silver discussion" do
          assert_equal(false, assigns(:discussions).include?(@silver_discussion))
        end
      end

      context "when logged in as registered user" do
        setup do
          new_request(@community, @registered_user)
          get :index
        end

        should "see public discussion" do
          assert_equal(true, assigns(:discussions).include?(@public_discussion))
        end
        should "see registered discussion" do
          assert_equal(true, assigns(:discussions).include?(@registered_discussion))
        end
        should "not see gold discussion" do
          assert_equal(false, assigns(:discussions).include?(@gold_discussion))
        end
        should "not see silver discussion" do
          assert_equal(false, assigns(:discussions).include?(@silver_discussion))
        end
      end

      context "when logged in as gold user" do
        setup do
          new_request(@community, @gold_user)
          get :index
        end

        should "see public discussion" do
          assert_equal(true, assigns(:discussions).include?(@public_discussion))
        end
        should "see registered discussion" do
          assert_equal(true, assigns(:discussions).include?(@registered_discussion))
        end
        should "see gold discussion" do
          assert_equal(true, assigns(:discussions).include?(@gold_discussion))
        end
        should "not see silver discussion" do
          assert_equal(false, assigns(:discussions).include?(@silver_discussion))
        end
      end

      context "when logged in as silver user" do
        setup do
          new_request(@community, @silver_user)
          get :index
        end

        should "see public discussion" do
          assert_equal(true, assigns(:discussions).include?(@public_discussion))
        end
        should "see registered discussion" do
          assert_equal(true, assigns(:discussions).include?(@registered_discussion))
        end
        should "not see gold discussion" do
          assert_equal(false, assigns(:discussions).include?(@gold_discussion))
        end
        should "see silver discussion" do
          assert_equal(true, assigns(:discussions).include?(@silver_discussion))
        end
      end
    end
  end
end
