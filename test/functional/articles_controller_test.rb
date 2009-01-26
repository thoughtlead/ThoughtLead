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

      @public_article = Article.make(:community => @community)

      @registered_content = Content.make(:user => User.make(:community => @community), :registered => true)
      @registered_article = Article.make(:community => @community, :content => @registered_content)

      @gold_content = Content.make(:user => User.make(:community => @community), :registered => true, :access_classes => [@gold])
      @gold_article = Article.make(:community => @community, :content => @gold_content)

      @silver_content = Content.make(:user => User.make(:community => @community), :registered => true, :access_classes => [@silver])
      @silver_article = Article.make(:community => @community, :content => @silver_content)
    end

    context "when not logged in" do
      setup do
        new_request(@community, nil)
      end

      should "be able to see public article" do
        get :show, { :id=> @public_article.id }
        assert_response :success
      end

      should "not be able to see registered article" do
        get :show, { :id=> @registered_article.id }
        assert_response :redirect
      end

      should "not be able to see gold article" do
        get :show, { :id=> @gold_article.id }
        assert_response :redirect
      end

      should "not be able to see silver article" do
        get :show, { :id=> @silver_article.id }
        assert_response :redirect
      end

      context "when viewing index" do
        setup do
          get :index
          assert_response :success
          assert @articles = assigns(:articles), "Cannot find @articles"
        end

        should "list public article" do
          assert @articles.include?(@public_article)
        end

        should "List registered article" do
          assert @articles.include?(@registered_article)
        end

        should "List gold article" do
          assert @articles.include?(@gold_article)
        end

        should "List silver article" do
          assert @articles.include?(@silver_article)
        end
      end
    end

    context "when logged in as a registered user" do
      setup do
        new_request(@community, @registered_user)
      end

      should "be able to see public article" do
        get :show, { :id=> @public_article.id }
        assert_response :success
      end

      should "be able to see registered article" do
        get :show, { :id=> @registered_article.id }
        assert_response :success
      end

      should "not be able to see gold article" do
        get :show, { :id=> @gold_article.id }
        assert_response :redirect
      end

      should "not be able to see silver article" do
        get :show, { :id=> @silver_article.id }
        assert_response :redirect
      end

      context "when viewing index" do
        setup do
          get :index
          assert_response :success
          assert @articles = assigns(:articles), "Cannot find @articles"
        end

        should "list public article" do
          assert @articles.include?(@public_article)
        end

        should "list registered article" do
          assert @articles.include?(@registered_article)
        end

        should "List gold article" do
          assert @articles.include?(@gold_article)
        end

        should "List silver article" do
          assert @articles.include?(@silver_article)
        end
      end
    end

    context "when logged in as a gold user" do
      setup do
        new_request(@community, @gold_user)
      end

      should "be able to see public article" do
        get :show, { :id=> @public_article.id }
        assert_response :success
      end

      should "be able to see registered article" do
        get :show, { :id=> @registered_article.id }
        assert_response :success
      end

      should "be able to see gold article" do
        get :show, { :id=> @gold_article.id }
        assert_response :success
      end

      should "not be able to see silver article" do
        get :show, { :id=> @silver_article.id }
        assert_response :redirect
      end

      context "when viewing index" do
        setup do
          get :index
          assert_response :success
          assert @articles = assigns(:articles), "Cannot find @articles"
        end

        should "list public article" do
          assert @articles.include?(@public_article)
        end

        should "list registered article" do
          assert @articles.include?(@registered_article)
        end

        should "list gold article" do
          assert @articles.include?(@gold_article)
        end

        should "List silver article" do
          assert @articles.include?(@silver_article)
        end
      end
    end

    context "when logged in as a silver user" do
      setup do
        new_request(@community, @silver_user)
      end

      should "be able to see public article" do
        get :show, { :id=> @public_article.id }
        assert_response :success
      end

      should "be able to see registered article" do
        get :show, { :id=> @registered_article.id }
        assert_response :success
      end

      should "not be able to see gold article" do
        get :show, { :id=> @gold_article.id }
        assert_response :redirect
      end

      should "be able to see silver article" do
        get :show, { :id=> @silver_article.id }
        assert_response :success
      end

      context "when viewing index" do
        setup do
          get :index
          assert_response :success
          assert @articles = assigns(:articles), "Cannot find @articles"
        end

        should "list public article" do
          assert @articles.include?(@public_article)
        end

        should "list registered article" do
          assert @articles.include?(@registered_article)
        end

        should "List gold article" do
          assert @articles.include?(@gold_article)
        end

        should "list silver article" do
          assert @articles.include?(@silver_article)
        end
      end
    end
  end
end
