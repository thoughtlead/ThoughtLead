require File.dirname(__FILE__) + '/../test_helper'

class AccessClassesControllerTest < ActionController::TestCase
  def test_create_access_class_without_children
    owner = users :c3_community_owner
    community = communities :c3

    new_request(community,owner)
    post :create, {:access_class => {:name => "new classy", :child_ids => []}}
    assert_response :redirect
  end

  def test_create_access_class_with_children
    owner = users :c3_community_owner
    community = communities :c3

    new_request(community,owner)
    post :create, {:access_class => {:name => "new classy", :child_ids => [access_classes(:c3_ultrapremium).id,
        access_classes(:c3_premium).id]}}

    assert_response :redirect

    the_new_class = AccessClass.find_by_name("new classy")
    assert 2, the_new_class.children.size
    assert the_new_class.children.include?(access_classes(:c3_ultrapremium))
    assert the_new_class.children.include?(access_classes(:c3_premium))
  end

  def test_update_access_class_without_children
    owner = users :c3_community_owner
    community = communities :c3
    premium = AccessClass.find(access_classes(:c3_premium).id)
    new_name = "new classy"

    new_request(community,owner)
    post :update, {:id => premium.id, :access_class => {:name => new_name, :child_ids => []}}

    assert_response :redirect

    premium.reload
    assert_equal new_name, premium.name
  end

  def test_update_access_class_without_children
    owner = users :c3_community_owner
    community = communities :c3
    premium = AccessClass.find(access_classes(:c3_premium).id)
    new_name = "new classy"

    new_request(community,owner)
    post :update, {:id => premium.id, :access_class => {:name => new_name, :child_ids => [access_classes(:c3_ultrapremium).id, access_classes(:c3_premium).id]}}

    assert_response :redirect

    premium.reload
    assert_equal new_name, premium.name
  end
end
