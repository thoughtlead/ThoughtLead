ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

$: << File.expand_path(File.dirname(__FILE__) + "/integration/dsl")
require 'basics_dsl'
require 'thought_lead_dsl'

require 'redgreen' unless ENV['TM_MODE']
require 'test_help'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all
  
  def assert_unordered_arrays_equal(expected, actual, object_display_method = :to_s, message = '')
    assert_arrays_equal(expected.sort, actual.sort, object_display_method, message)
  end
  

end


class ActionController::IntegrationTest

  def new_session(subdomain, &block) 
    open_session do | session | 
      session.extend(BasicsDsl)
      session.extend(ThoughtLeadDsl)
      session.host!("#{subdomain}.nokahuna.dev")
      session.instance_eval(&block) if block
      session
    end 
  end 
  
  def new_session_as(user_symbol, &block)
    user = users(user_symbol)
    session = new_session(user.community.subdomain)
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
        @integration_session = new_session("c1")
      end
    end
  end
end


