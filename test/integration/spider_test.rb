require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :users, :communities
  include Caboose::SpiderIntegrator
  
  def test_spider_no_login
    get '/'
    assert_response :success
    spider(@response.body, '/',     :verbose => true,
    :ignore_urls => ['/login', %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => [])
  end
  
  def test_spider_with_login
    get 'http://testing.localhost.com/login'
    assert_response :success
    post 'http://testing.localhost.com/sessions', :login => 'test', :password => 'test'
    assert session[:user]
    assert_response :redirect
    assert_redirected_to '/'
    follow_redirect!
    
    spider(@response.body, '/', 
    :verbose => true,
    :ignore_urls => ['/login', %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}], 
    :ignore_forms => [])
  end
end
