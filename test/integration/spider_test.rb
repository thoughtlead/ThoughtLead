require "#{File.dirname(__FILE__)}/../test_helper"

class SpiderTest < ActionController::IntegrationTest
  fixtures :all

  IgnoreURLs = ['/login', 'http://www.onemillionmarketers.com', 'http://thoughtlead.com/', %r{^javascript:.*}, %r{^.*/categories/[0-9]+}, %r{^.+logout}, %r{^.+delete.?}, %r{^.+/destroy.?}]
  ExcludeFormPatterns = [%r{^.*/search}, %r{^.*/login}, %r{^.*/session}, %r{^.*/community/edit}]

  include Caboose::SpiderIntegrator

  def test_spider_site_no_search
    # splash page, no login
    get '/'
    assert_response :success
    run_spider('/')

    # testing community page, no login
    get 'http://testing.dev'
    assert_response :success
    run_spider('/')

    # testing community, registered user
    get 'http://testing.dev/login'
    assert_response :success
    post 'http://testing.dev/session', :login => 'test', :password => 'test'
    assert_equal users(:test).id, session[:user_id]
    assert_response :redirect
    follow_redirect!
    get 'http://testing.dev/'
    run_spider

    # testing community, premium user
    get 'http://testing.dev/login'
    assert_response :success
    post 'http://testing.dev/session', :login => 'premium', :password => 'test'
    assert_equal users(:premium).id, session[:user_id]
    assert_response :redirect
    follow_redirect!
    get 'http://testing.dev/'
    run_spider
  end

  private

  def run_spider(url = 'http://testing.dev/')
    spider(@response.body, url, :verbose => false, :ignore_urls => IgnoreURLs, :ignore_forms => ExcludeFormPatterns)
  end
end
