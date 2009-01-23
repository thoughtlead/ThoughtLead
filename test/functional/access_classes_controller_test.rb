require File.dirname(__FILE__) + '/../test_helper'

class AccessClassesControllerTest < ActionController::TestCase
  context "AccessClassesController" do
    setup do
      @community = Community.make
      @owner = @community.owner
      @gold = AccessClass.make(:community => @community)
      @silver = AccessClass.make(:community => @community)
    end

    should "be able to create access class without children" do
      new_request(@community, @owner)
      post :create, {:access_class => {:name => "new classy", :child_ids => []}}
      assert_response :redirect

      @community.reload
      assert_not_nil @community.access_classes.find_by_name("new classy")
    end

    should "be able to create access class with children" do
      new_request(@community, @owner)
      post :create, {:access_class => {:name => "new classy", :child_ids => [@gold.id, @silver.id]}}

      assert_response :redirect

      @community.reload

      a = @community.access_classes.find_by_name "new classy"
      assert 2, a.children.size
      assert a.children.include?(@gold)
      assert a.children.include?(@silver)
    end

    should "be able to update access class without children" do
      new_request(@community, @owner)
      put :update, {:id => @gold.id, :access_class => {:name => "new classy", :child_ids => []}}

      assert_response :redirect

      @gold.reload
      assert_equal "new classy", @gold.name
    end

    should "be able to update access class with children" do
      new_request(@community, @owner)
      put :update, {:id => @gold.id, :access_class => {:name => "new classy",  :child_ids => [@silver.id,]}}

      assert_response :redirect

      @gold.reload
      assert_equal "new classy", @gold.name

      assert 1, @gold.children.size
      assert @gold.children.include?(@silver)
    end
  end
end
