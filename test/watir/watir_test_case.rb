require File.dirname(__FILE__) + '/watir_setup'

class WatirTestCase < Test::Unit::TestCase
  
  protected
  
  def teardown
    $ie.link(:text, "Logout").click if $ie.link(:text, "Logout").exist?
  end

end