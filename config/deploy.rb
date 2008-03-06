require 'spacesuit/recipes'

set :client, "verticality"
set :application, "thoughtlead"

set :deploy_to, "/var/www/#{client}/#{application}"
set :domain, "#{application}.#{client}.dock.terralien.biz"

set :user, client
set :repository, "https://terralien.devguard.com/svn/#{client}/#{application}/trunk"
set :svn_username, "duff"
set :rails_env, "production"

role :web, domain
role :app, domain
role :db,  domain, :primary => true