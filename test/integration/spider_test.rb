require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :articles, :attachments, :categories, :categorizations,
    :chapters, :communities, :contents, :courses, :discussions, :emails,
    :lessons, :themes, :users
  
  include Caboose::SpiderIntegrator
  
  def test_spider_no_login
    get '/'
    assert_response :success
    spider(@response.body, '/',     :verbose => true,
    :ignore_urls => ['/login', %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => [])
  end
  
  def test_spider_with_login
    get 'http://testing.whatever.com/login'
    assert_response :success
    post 'http://testing.whatever.com/sessions', :login => 'test', :password => 'test'
    assert session[:user]
    assert_response :redirect
    assert_redirected_to '/'
    follow_redirect!

    get 'http://testing.whatever.com/'
    spider(@response.body, 'http://testing.whatever.com/',
    :verbose => true,
    :ignore_urls => ['/login', %r{^.*/categories/[0-9]+}, %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => [])
  end
end
