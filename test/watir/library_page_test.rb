require File.dirname(__FILE__) + '/watir_test_case'

class LibraryPageTest < WatirTestCase
  self.use_transactional_fixtures = false
  fixtures :users, :communities, :contents, :articles, :categories

#  def test_work_to_do
#    assert false
#  end
  
  def test_add_an_article
    $ie.link(:text, /Add an Article/).click
    $ie.text_field(:id, "content_title").set("a new article")
    $ie.text_field(:id, "content_teaser").set("the new article teaser")
    $ie.text_field(:id, "content_body").set("the new article body")
    $ie.form(:id, "new_article").submit
    $ie.link(:text, "a new article").click
    assert $ie.h1(:text, "a new article").exist?
    assert $ie.p(:text, "the new article teaser").exist?
    assert $ie.div(:id, "content_body").text.include?("the new article body")
  end
  
  def test_edit_categories
    $ie.link(:text, "Edit Categories").click
    
    $ie.text_field(:id, "category_name").set("a new category")
    $ie.form(:id, "new_category").submit
    li = $ie.li(:text, /a new category/)
    #puts "\n\n" + li.text + "\n\n"
    
    li.link(:text,"Edit").click
    $ie.text_field(:id, "category_name").set("an edited category")
    $ie.form(:id, /edit_category/).submit

    assert !($ie.li(:text, /a new category/).exist?)
    li = $ie.li(:text, /an edited category/)
    #puts "\n\n" + li.text + "\n\n"

    li.link(:text,"Delete").click
    assert !($ie.li(:text, /an edited category/).exist?)
  end

  def test_category_visibility
    assert !($ie.link(:text,(categories :empty).name).exist?)
    $ie.link(:text,"Edit Categories").click
    assert $ie.li(:text, /#{(categories :empty).name}/).exist?
  end
  
  def test_select_category
    #full
    assert $ie.link(:text, (contents :category_none_article_1).title).exist?
    assert $ie.link(:text, (contents :category_1_article_1).title).exist?
    assert $ie.link(:text, (contents :category_2_article_1).title).exist?
    assert $ie.link(:text, (contents :category_1_2_article_1).title).exist?
    #cat 1
    $ie.link(:text, (categories :category_1).name).click
    assert !($ie.link(:text, (contents :category_none_article_1).title).exist?)
    assert $ie.link(:text, (contents :category_1_article_1).title).exist?
    assert !($ie.link(:text, (contents :category_2_article_1).title).exist?)
    assert $ie.link(:text, (contents :category_1_2_article_1).title).exist?
    #cat 2
    $ie.link(:text, (categories :category_2).name).click
    assert !($ie.link(:text, (contents :category_none_article_1).title).exist?)
    assert !($ie.link(:text, (contents :category_1_article_1).title).exist?)
    assert $ie.link(:text, (contents :category_2_article_1).title).exist?
    assert $ie.link(:text, (contents :category_1_2_article_1).title).exist?
    #general
    $ie.link(:text, "General").click
    assert $ie.link(:text, (contents :category_none_article_1).title).exist?
    assert !($ie.link(:text, (contents :category_1_article_1).title).exist?)
    assert !($ie.link(:text, (contents :category_2_article_1).title).exist?)
    assert !($ie.link(:text, (contents :category_1_2_article_1).title).exist?)
    #full
    $ie.link(:text, "Full Library").click
    assert $ie.link(:text, (contents :category_none_article_1).title).exist?
    assert $ie.link(:text, (contents :category_1_article_1).title).exist?
    assert $ie.link(:text, (contents :category_2_article_1).title).exist?
    assert $ie.link(:text, (contents :category_1_2_article_1).title).exist?
  end
  
  private
  
  def setup
    $ie.goto($COMMUNITY_URL)
    $ie.link(:text, "Login").click
    $ie.text_field(:id, "login").set((users :admin).login)
    $ie.text_field(:id, "password").set("test")    
    $ie.form(:action, "/sessions").submit
    $ie.goto($COMMUNITY_URL + "library")
  end
  
end