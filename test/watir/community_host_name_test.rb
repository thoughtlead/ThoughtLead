require File.dirname(__FILE__) + '/watir_test_case'

class CommunityHostNameTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities, :contents, :articles
  
#  def test_work_to_do
#    assert false
#  end
  
  def test_splashscreen_visibility
    $ie.goto($COMMUNITY_URL)
    assert !($ie.image(:src, /thoughtlead_logo/).exist?)
    $ie.goto($BASE_URL)
    assert $ie.image(:src, /thoughtlead_logo/).exist?
  end
  
  def test_new_community_visibility
    $ie.goto($COMMUNITY_URL + "communities/new")
    assert !($ie.form(:id, "new_community").exist?)
    $ie.goto($BASE_URL + "communities/new")
    assert $ie.form(:id, "new_community").exist?
  end
  
  def test_new_community
    $ie.goto("http://newcommunity.com:" + $PORT + "/")
    assert !($ie.text.include?("Welcome"))
    $ie.goto($BASE_URL + "communities/new")
    $ie.text_field(:id, "community_name").set("New Community")    
    $ie.text_field(:id, "user_login").set("newcommunityadmin")    
    $ie.text_field(:id, "user_email").set("newcommunityadmin@dot.dot")    
    $ie.text_field(:id, "user_password").set("admin password")    
    $ie.text_field(:id, "user_password_confirmation").set("admin password")    
    $ie.text_field(:id, "community_host").set("newcommunity.com")
    $ie.form(:id, "new_community").submit
    #TODO assert gone to spreedly???
    c = Community.find_by_host("newcommunity.com")
    c.active = true
    c.save
    $ie.goto("http://newcommunity.com:" + $PORT + "/")
    $ie.link(:text, "Login").click
    $ie.text_field(:id, "login").set("newcommunityadmin")
    $ie.text_field(:id, "password").set("admin password")
    $ie.form(:action, "/sessions").submit
    assert_equal "Logged in successfully", $ie.div(:id, "flash").text
  end
  
  def test_communities_are_separated
    $ie.goto($COMMUNITY_URL + "login")
    $ie.text_field(:id, "login").set("test")
    $ie.text_field(:id, "password").set("test")
    $ie.form(:action, "/sessions").submit
    assert_equal "Invalid login or password.", $ie.div(:id, "flash").text
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")
    $ie.form(:action, "/sessions").submit
    $ie.goto($COMMUNITY_URL + "articles/" + (articles :about_dogs).id.to_s)
    assert !($ie.text.include?((contents :dogs).title))
  end
  
  private
  
end