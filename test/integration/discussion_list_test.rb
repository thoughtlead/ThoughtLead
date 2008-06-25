require File.dirname(__FILE__) + '/../test_helper' 

class DiscussionListTest < ActionController::IntegrationTest
  # fixtures :your, :models
  
  def setup
    @c = Category.new(:name=>"Japan", :description=>"Discussions about the land of the rising sun.")
    @c.save!
    @d = Discussion.new(:title=>"Ninjas", :body=>"Ninjas are ultra powerful", :category=>@c)
    @d.save!
  end
  
  def test_discussion_for_all_categories
    get "/discussions"
    assert_response :success
    
    # Ensure no Category name and description appear at the top of the list
    assert_select "div[id=primary] h2", false
    assert_select "div[id=primary] h3", false
  end
  
  def test_discussion_for_one_category
    get "/discussions?category=#{@c.id}"
    assert_response :success
   
    
    # Ensure the Category name and description appear at the top of the list
    assert_select "div[id=primary] h2", @c.name
    assert_select "div[id=primary] h3", @c.description
  end
  
end
