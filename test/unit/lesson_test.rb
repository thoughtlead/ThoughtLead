require File.dirname(__FILE__) + '/../test_helper' 

class LessonTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  def test_accessibility_rules
    unknown_user = :false
    registered_user = users :duff
    premium_user = users :daniel
    owner = users :sam
    
    public = lessons :public_lesson
    registered = lessons :registered_lesson
    premium = lessons :premium_lesson
    draft = lessons :premium_draft_lesson
    
    assert public.accessible_to(unknown_user)
    assert public.accessible_to(registered_user)
    assert public.accessible_to(premium_user)
    assert public.accessible_to(owner)

    assert !registered.accessible_to(unknown_user)
    assert registered.accessible_to(registered_user)
    assert registered.accessible_to(premium_user)
    assert registered.accessible_to(owner)

    assert !premium.accessible_to(unknown_user)
    assert !premium.accessible_to(registered_user)
    assert premium.accessible_to(premium_user)
    assert premium.accessible_to(owner)

    assert !draft.accessible_to(unknown_user)
    assert !draft.accessible_to(registered_user)
    assert !draft.accessible_to(premium_user)
    assert draft.accessible_to(owner)

    
  end
end
