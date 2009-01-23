require File.dirname(__FILE__) + '/../test_helper'

class CommunityTest < ActiveSupport::TestCase
  context "A Community" do
    setup do
      @community = Community.make
    end

    should "restrict hosts in the reserved list" do
      reserved = %w(www db app server test staging web files ftp mail)
      reserved.each do | each |
        @community.host = "#{each}.#{$app_host}"
        assert !@community.valid?, "#{each}.#{$app_host} should be reserved"
        assert_equal(["Host is reserved"], @community.errors.full_messages, "#{each} message should be right")
      end
    end

    should "allow hosts that are not in the reserved list" do
      unreserved = %w(wwwfine db34a www3123a app1233ba server112ab test12a staging12a web12a with-dash mail3a news3a ftp3a files3a www1 www3123 db3 db121231 app4 app323 server1 server2321 test3 test123 staging1 staging123 web2 web1233 ftp3 mail3 files3)
      unreserved.each do | each |
        @community.host = "#{each}.#{$app_host}"
        assert @community.valid?, "#{each}.#{$app_host} should be valid"
      end
    end

    should "restrict hosts with invalid characters" do
      with_invalid_chars = %w(ab% `32` #212 aa_1b)
      with_invalid_chars.each do | each |
        @community.host = "#{each}.#{$app_host}"
        assert !@community.valid?, "#{each}.#{$app_host} should be invalid"
        assert_equal(["Host is invalid"], @community.errors.full_messages)
      end
    end

    should "restrict use of $app_host" do
      @community.host = $app_host
      assert !@community.valid?, "#{$app_host} should be invalid"
    end

    should "allow use of reserved hosts as a subdomain" do
      reserved_but_not_apphost_domain = %w(www db app server test staging web files www1 www3123 db3 db121231 app4 app323 server1 server2321 test3 test123 staging1 staging123 web2 web1233 ftp ftp3 mail mail3 files3)
      reserved_but_not_apphost_domain.each do | each |
        @community.host = "#{each}.something.com"
        assert @community.valid?, "#{each}.something.com should be valid"
      end
    end
  end
end
