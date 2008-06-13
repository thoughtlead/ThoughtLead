RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  
  config.load_paths << "#{RAILS_ROOT}/app/models/spreedly"

  config.action_controller.session = {
    :session_key => '_thoughtlead_session',
    :secret      => 'd04b52dbb492216963ed017bbb9da3766df2d19cf7f47e9a65e4b23056989d28740ff22f84b00c1d584f393c43e7d7d35f2ab74d0b5b650bc9b9ba0efe51c9d0'
  }

  config.active_record.default_timezone = :utc
end

require RAILS_ROOT + '/lib/attachment_fu_windows_bug_fixes'