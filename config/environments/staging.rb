# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = false

ENV['INLINEDIR'] = Rails.root + "/tmp" 

$app_host = 'thoughtlead.intranet.ternarysoftware.com'

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => "smtp.sendgrid.net",
  :port           => "25",
  :authentication => :plain,
  :user_name      => 'stevetrumpet@gmail.com',
  :password       => 'shilke',
  :domain         => 'thoughtlead.com',
}

config.after_initialize do
  ActiveMerchant::Billing::Base.gateway_mode = :test
end

SslRequirement.disable_ssl_check = true

# This suffix gets removed from the host before looking up the community
# i.e., "demo.thoughtlead.com.tl-dev.local" becomes "demo.thoughtlead.com"
$host_suffix = 'tl-staging.wideopenspac.es'