require File.dirname(__FILE__) + '/../test_helper'

class CommunityTest < ActiveSupport::TestCase

  def test_owner_becomes_community_user_when_community_created
    duff = users(:duff)
    community = Community.new(:name => "TheName", :subdomain => "thesubdomain")
    community.owner = duff
    assert_equal([], community.users)
    
    community.save!  
    assert_equal([duff], community.users)
    
    community.reload
    assert_equal([duff], community.users)
  end
  
end
