# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on.
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "hpricot"
  config.gem "image_science"
  config.gem "builder"
  config.gem "xml-simple", :lib => "xmlsimple"
  config.gem "RedCloth"
  config.gem "mime-types", :lib => "mime/types"
  config.gem "aws-s3", :lib => "aws/s3"
  config.gem "colored"
  config.gem "map_by_method"
  config.gem "chronic"
  config.gem "mini_magick"
  config.gem "fastercsv"
  config.gem "rexml-expansion-fix"
  config.gem "mislav-will_paginate", :lib => "will_paginate", :source => "http://gems.github.com"
  config.gem "lockfile"
  config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
  config.gem "faker"
  config.gem "mocha"
  config.gem "panda"
  
  config.gem "wideopenspaces-gstats", :source => "http://gems.github.com", :lib => 'gstats'

  # Only load the plugins named here, in the order given. By default, all plugins
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_thoughtlead_session',
    :secret      => 'd04b52dbb492216963ed017bbb9da3766df2d19cf7f47e9a65e4b23056989d28740ff22f84b00c1d584f393c43e7d7d35f2ab74d0b5b650bc9b9ba0efe51c9d0'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # Please note that observers generated using script/generate observer need to have an _observer suffix
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
end

require RAILS_ROOT + '/lib/attachment_fu_windows_bug_fixes'
require RAILS_ROOT + '/lib/strip_whitespace'

Ultrasphinx::Search.excerpting_options = HashWithIndifferentAccess.new({
  :before_match => '<strong class="match">',
  :after_match => '</strong>',
  :chunk_separator => "...",
  :limit => 128,
  :around => 3,
  :content_methods => [['title', 'display_name'], ['login'], ['body', 'description', 'content', 'about'], ['teaser'], ['interests'], ['location'], ['zipcode']]
  })
