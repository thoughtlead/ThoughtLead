require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase
  context "A Article" do
    setup do
      @community = Community.make
      @user = User.make(:community => @community)
      @content = Content.make(:user => User.make(:community => @community))
      @article = Article.make(:community => @community, :content => @content)
    end

    context "that doesn't require registered users" do
      setup do
        @content.registered = false
      end

      should "be visible to nil users" do
        assert_equal(true, @article.visible_to(nil))
      end

      should "be visible to registered users" do
        assert_equal(true, @article.visible_to(@user))
      end

      should "be visible to the community owner" do
        assert_equal(true, @article.visible_to(@community.owner))
      end
    end

    context "that requires registered users" do
      setup do
        @content.registered = true
        @content.save!
      end

      context "with no access classes" do
        should "not be visible to nil users" do
          assert_equal(false, @article.visible_to(nil))
        end

        should "be visible to registered users" do
          assert_equal(true, @article.visible_to(@user))
        end

        should "be visible to the community owner" do
          assert_equal(true, @article.visible_to(@community.owner))
        end
      end

      context "with required access class" do
        setup do
          @access_class = AccessClass.make(:community => @community)
          @other_access_class = AccessClass.make(:community => @community)
          @other_access_class.children << @access_class
          @yet_another_access_class = AccessClass.make(:community => @community)
                   
          @content.access_classes << @access_class
          @user_with_access = User.make(:community => @community, :access_classes => [@access_class])
          
          # other_access_class -> access_class (child)
          # Can access article!
          @user_with_other_access = User.make(:community => @community, :access_classes => [@other_access_class])
          
          # other_access_class, yet_another_access_class
          # Cannot access article!
          @user_with_multiple_access = User.make(
            :community => @community, :access_classes => [@other_access_class, @yet_another_access_class])
          
          # access_class, yet_another_access_class
          # Can access article!
          @user_with_correct_multiple_access = User.make(
              :community => @community, :access_classes => [@access_class, @yet_another_access_class])
        end

        should "not be visible to nil users" do
          assert_equal(false, @article.visible_to(nil))
        end

        should "not be visible to registered users" do
          assert_equal(false, @article.visible_to(@user))
        end

        should "be visible to users with the right access" do
          assert_equal(true, @article.visible_to(@user_with_access))
        end

        should "be visible to the community owner" do
          assert_equal(true, @article.visible_to(@community.owner))
        end
        
        context "and only one access class" do
          should "be visible to a user with a parent access level to content access level" do
            assert_equal(true, @article.visible_to(@user_with_other_access))
          end
        end
        
        context "and more than one access class" do
          should "not be visible to a user with multiple access classes despite parenthood
            if the exact class is not found" do
            assert_equal(false, @article.visible_to(@user_with_multiple_access))
          end
          
          should "be visible to a user with multiple access classes if exact class found" do
            assert_equal(true, @article.visible_to(@user_with_correct_multiple_access))
          end
        end
      end
    end
  end
end