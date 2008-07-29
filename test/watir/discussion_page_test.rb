require File.dirname(__FILE__) + '/watir_test_case'

class DiscussionPageTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities, :discussions, :themes
  
  def test_edit_discussion
    $ie.link(:text, (discussions :expert_discussion).title).click
    assert $ie.link(:text, "General").exist?
    $ie.link(:text, "Edit this Discussion").click
    $ie.text_field(:id, "discussion_title").set("an edited discussion")
    $ie.text_field(:id, "discussion_body").set("the edited discussion body")
    $ie.select_list(:id, "discussion_theme_id").select((themes :empty).name)
    $ie.form(:id, /edit_discussion/).submit
    assert $ie.h1(:text, "an edited discussion").exist?
    assert $ie.p(:text, "the edited discussion body").exist?
    assert $ie.link(:text, (themes :empty).name).exist?
    $ie.link(:text, /Return to Discussions/).click
    assert $ie.link(:text, "an edited discussion").exist?
    $ie.link(:text, (themes :empty).name).click
    assert $ie.link(:text, "an edited discussion").exist?        
  end
  
  def test_edit_discussion_link_visibility
    $ie.link(:text, (discussions :premium_user_discussion).title).click
    assert $ie.link(:text, "Edit this Discussion").exist?    
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :watir_premium).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Discussions").click
    $ie.link(:text, (discussions :premium_user_discussion).title).click
    assert $ie.link(:text, "Edit this Discussion").exist?    
    $ie.link(:text, "Logout").click
    $ie.text_field(:id, "login").set((users :nonadmin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Discussions").click
    $ie.link(:text, (discussions :premium_user_discussion).title).click    
    assert !$ie.link(:text, "Edit this Discussion").exist?    
  end
  
  def test_add_a_response_to_a_discussion
    response_text = "This is a new response!"
    $ie.link(:text, (discussions :expert_discussion).title).click
    $ie.text_field(:id, "response_body").set(response_text)    
    $ie.button(:value, /Post this response/).click
    assert $ie.text.include?(response_text)
  end  
  
  def test_responses_added_in_correct_order
    response_text = "This is a new response!"
    $ie.link(:text, (discussions :response_order_discussion).title).click
    $ie.text_field(:id, "response_body").set("#{response_text}1")    
    $ie.button(:value, /Post this response/).click
    $ie.text_field(:id, "response_body").set("#{response_text}2")    
    $ie.button(:value, /Post this response/).click
    responses = $ie.divs.find_all{|div| div.class_name == 'comment_body'}
    
    assert_equal 2, responses.length
    assert_equal "#{response_text}1", responses[0].text
    assert_equal "#{response_text}2", responses[1].text
  end  
  
  private
  
  def setup
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.link(:text, "Discussions").click
  end
  
end