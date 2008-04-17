require 'spacesuit/recipes'

set :client, "verticality"
set :application, "thoughtlead"

set :deploy_to, "/var/www/#{client}/#{application}"
set :domain, "#{application}.#{client}.dock.terralien.biz"

set :user, client
set :svn_username, "duff"
set :rails_env, "production"

default_run_options[:pty] = true
set :repository,  "git@github.com:duff/thoughtlead.git"
set :scm, "git"
set :keep_releases, 10

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :rails_revision, '420c4b3d8878156d04f45e47050ddc62ae00c68c'

before "deploy:update_code", "deploy:pending:default" 
after  "deploy:update_code", "deploy:cleanup"
