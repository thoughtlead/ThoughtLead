require File.dirname(__FILE__) + '/../test_helper'

class ArticlesControllerTest < ActionController::TestCase
  context "ArticlesController" do
    setup do
      @community = Community.make
      @gold = AccessClass.make(:community => @community)
      @silver = AccessClass.make(:community => @community)

      @registered_user = User.make(:community => @community)
      @gold_user = User.make(:community => @community, :access_class => @gold)
      @silver_user = User.make(:community => @community, :access_class => @silver)
    end

    context "with a public article" do
      setup do
        @article = Article.make(:community => @community)
      end

      should "allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @article.id }
        assert_response :success
      end

      should "allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end

      should "allow access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end

      should "allow access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end
    end

    context "with a registered lesson" do
      setup do
        @content = Content.make(:user => User.make(:community => @community), :registered => true)
        @article = Article.make(:community => @community, :content => @content)
      end

      should "not allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @article.id }
        assert_response :redirect
      end

      should "allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end

      should "allow access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end

      should "allow access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end
    end

    context "with a gold lesson" do
      setup do
        @content = Content.make(:user => User.make(:community => @community), :registered => true, :access_classes => [@gold])
        @article = Article.make(:community => @community, :content => @content)
      end

      should "not allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @article.id }
        assert_response :redirect
      end

      should "not allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @article.id }
        assert_response :redirect
      end

      should "allow access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end

      should "not access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @article.id }
        assert_response :redirect
      end
    end

    context "with a silver lesson" do
      setup do
        @content = Content.make(:user => User.make(:community => @community), :registered => true, :access_classes => [@silver])
        @article = Article.make(:community => @community, :content => @content)
      end

      should "not allow access to public" do
        new_request(@community, nil)
        get :show, { :id=> @article.id }
        assert_response :redirect
      end

      should "not allow access to registered user" do
        new_request(@community, @registered_user)
        get :show, { :id=> @article.id }
        assert_response :redirect
      end

      should "not access to gold user" do
        new_request(@community, @gold_user)
        get :show, { :id=> @article.id }
        assert_response :redirect
      end

      should "allow access to silver user" do
        new_request(@community, @silver_user)
        get :show, { :id=> @article.id }
        assert_response :success
      end
    end
  end
end
