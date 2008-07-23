require File.dirname(__FILE__) + '/watir_test_case'

class PeopleTabTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities

#  def test_work_to_do
#    assert false
#  end

  def test_shows_expert_status
    li = $ie.li(:text, /#{(users :expert).to_s}/)
    assert li.image(:src, /star/).exist?
    li = $ie.li(:text, /#{(users :registered).to_s}/)
    assert !li.image(:src, /star/).exist?
  end

  def test_disabled_user_visibility_and_display
    li = $ie.li(:text, /#{(users :disabled).to_s}/)
    #puts "\n" + li.html + "\n"
    assert !li.locate_tagged_element("strike",:text,(users :disabled).to_s).nil?
    li = $ie.li(:text, /#{(users :admin).to_s}/)
    #puts "\n" + li.html + "\n"
    assert li.locate_tagged_element("<strike>",:text,(users :admin).to_s).nil?    
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "People").click
    assert !$ie.li(:text, /#{(users :disabled).to_s}/).exist?
  end

  private
  
  def setup
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "People").click
  end
  
end