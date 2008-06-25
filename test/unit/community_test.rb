require File.dirname(__FILE__) + '/../test_helper' 

class CommunityTest < ActiveSupport::TestCase
  should "have its owner become a community user when the community is created" do
    duff = users(:duff)
    community = Community.new(:name => "TheName", :subdomain => "thesubdomain")
    community.owner = duff
    assert_equal([], community.users)
  
    community.save!  
    assert_equal([duff], community.users)
  
    community.reload
    assert_equal([duff], community.users)
  end

  should "restrict subdomains." do
    community = Community.new(:name => "TheName", :subdomain => "thesubdomain")
    assert community.valid?
  
    reserved = %w(www db app server test staging web files www1 www3123 db3 db121231 app4 app323 server1 server2321 test3 test123 staging1 staging123 web2 web1233 ftp ftp3 mail mail3 files3)
    reserved.each do | each |
      community.subdomain = each
      assert !community.valid?, "#{each} should be reserved"
      assert_equal(["Subdomain is reserved"], community.errors.full_messages, "#{each} message should be right")
    end
  
    unreserved = %w(wwwfine db34a www3123a app1233ba server112ab test12a staging12a web12a with-dash mail3a news3a ftp3a files3a)
    unreserved.each do | each |
      community.subdomain = each
      assert community.valid?, "#{each} should be valid"
    end
  
    with_invalid_chars = %w(ab% 32.21 `32` #212 aa_1b)
    with_invalid_chars.each do | each |
      community.subdomain = each
      assert !community.valid?, "#{each} should be invalid"
      assert_equal(["Subdomain is invalid"], community.errors.full_messages)
    end
  end
  
end
