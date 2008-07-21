ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

$: << File.expand_path(File.dirname(__FILE__) + "/integration/dsl")
require 'basics_dsl'
require 'thought_lead_dsl'

require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  def assert_unordered_arrays_equal(expected, actual, object_display_method = :to_s, message = '')
    assert_arrays_equal(expected.sort, actual.sort, object_display_method, message)
  end
  

end


class ActionController::IntegrationTest

  def new_session(host, &block) 
    open_session do | session | 
      session.extend(BasicsDsl)
      session.extend(ThoughtLeadDsl)
      session.host!(host)
      session.instance_eval(&block) if block
      session
    end 
  end 
  
  def new_session_as(user_symbol, &block)
    user = users(user_symbol)
    session = new_session(user.community.host)
    session.login(user_symbol)
    session.instance_eval(&block) if block
    session
  end 
  
  def logger
    Rails.logger
  end
    
end


module ActionController
  module Integration
    module Runner
      def reset!
        @integration_session = new_session("c1.nokahuna.dev")
      end
    end
  end
end

#TODO make this more test specific, it should work normally for watir tests for example
class ActiveRecord::Base
  def valid_community?  
    true
  end
end
