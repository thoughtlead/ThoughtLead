END {
  $ie.close if $ie
  $test_server.shutdown if $test_server
}

require File.dirname(__FILE__) + '/../test_helper'
require 'dispatcher'
require 'watir'
require 'mongrel'
require 'webrick'
require 'webrick_server'

$PORT = '3021'
$BASE_URL = 'http://localhost.com:' + $PORT + '/'
$COMMUNITY_URL = 'http://watirtest.localhost.com:' + $PORT + '/'
#$USER_PASSWORD = 'xxx'
#$USER = User.new {|u|
#      u.username = 'myuser'
#      u.new_password = $USER_PASSWORD
#      u.first_name = 'Test'
#      u.last_name = 'User'
#    }

#def create_user
#  $USER.save! unless User.find_by_username($USER.username)
#end

def start_test_webrick
  options = {
    :port        => $PORT,
    :ip          => "0.0.0.0",
    :environment => "test",
    :server_root => File.expand_path(RAILS_ROOT + "/public/"),
    :working_directory => File.expand_path(RAILS_ROOT),
    :server_type => WEBrick::SimpleServer
  }
  
  params = { :Port        => options[:port].to_i,
    :ServerType  => options[:server_type],
    :BindAddress => options[:ip],
    :AccessLog   => [] }
  
  $test_server = WEBrick::HTTPServer.new(params)
  $test_server.mount('/', DispatchServlet, options)
  
  trap("INT") { $test_server.shutdown }
  
  Thread.new do
    $test_server.start
  end
end

def start_and_setup_ie
  $ie = Watir::IE.new
  $ie.speed = :fast
  # login
  # english_locale      
end

#def login
#  $ie.goto($BASE_URL + 'users/login')
#  $ie.text_field(:name, 'user[username]').set($USER.username)
#  $ie.text_field(:name, 'user[password]').set($USER_PASSWORD)
#  $ie.button(:name, 'commit').click
#end

#def english_locale
## bindtextdomain('messages', "#{RAILS_ROOT}/locale", 'en', 'utf-8') # if gettext localization used
#  $ie.goto($BASE_URL + 'settings')
#  $ie.select_list(:name, 'settings[locale]').option(:value, 'en').select
#  $ie.button(:name, 'commit').click 
#end

# create_user
start_test_webrick
start_and_setup_ie
