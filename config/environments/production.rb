# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored < changed this to raise delivery errors for a test
config.action_mailer.raise_delivery_errors = false

$app_host = 'thoughtleadapp.com'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = { 
  :user_name => "steve@thoughtlead.com", 
  :password => "halcyon66", 
  :domain => "tpiprograms.com", 
  :address => "smtp.sendgrid.net", 
  :port => 587, 
  :authentication => :plain, 
  :enable_starttls_auto => true 
}

ENV['INLINEDIR'] = Rails.root + "/tmp" 