require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :articles, :attachments, :categories, :categorizations,
  :chapters, :communities, :contents, :courses, :discussions, :emails,
  :lessons, :themes, :users
  
  include Caboose::SpiderIntegrator
  
  def spiderize(exclude_form_patterns)
    # splash page, no login
    get '/'
    assert_response :success
    spider(@response.body, '/',     :verbose => true,
    :ignore_urls => ['/login', %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => exclude_form_patterns)
    
    # testing community page, no login
    get 'http://testing.whatever.com'
    assert_response :success
    spider(@response.body, '/',     :verbose => true,
    :ignore_urls => ['/login', %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => exclude_form_patterns)
    
    # testing community, registered user
    get 'http://testing.whatever.com/login'
    assert_response :success
    post 'http://testing.whatever.com/sessions', :login => 'test', :password => 'test'
    assert session[:user]
    assert_response :redirect
    follow_redirect!
    get 'http://testing.whatever.com/'
    spider(@response.body, 'http://testing.whatever.com/',
    :verbose => true,
    :ignore_urls => ['/login', %r{^.*/categories/[0-9]+}, %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => exclude_form_patterns)
    
    # testing community, premium user
    get 'http://testing.whatever.com/login'
    assert_response :success
    post 'http://testing.whatever.com/sessions', :login => 'premium', :password => 'test'
    assert session[:user]
    assert_response :redirect
    follow_redirect!
    get 'http://testing.whatever.com/'
    spider(@response.body, 'http://testing.whatever.com/',
    :verbose => true,
    :ignore_urls => ['/login', %r{^.*/categories/[0-9]+}, %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => exclude_form_patterns)
  end
  
  def test_spider_site_no_search
    spiderize([%r{^.*/search}])
  end
  
  def test_spider_site_with_search
    spiderize([])
  end
  
end

