require File.dirname(__FILE__) + '/../test_helper' 

class DiscussionTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  def test_accessibility_rules
    unknown_user = :false
    registered_user = users :duff
    premium_user = users :daniel
    
    public = discussions :its_coming
    premium = discussions :lost_my_monkey
    
    assert public.accessible_to(unknown_user)
    assert public.accessible_to(registered_user)
    assert public.accessible_to(premium_user)

    assert !premium.accessible_to(unknown_user)
    assert !premium.accessible_to(registered_user)
    assert premium.accessible_to(premium_user)
  end


end
