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
set :deploy_via, :remote_cache
set :keep_releases, 10

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :rails_revision, '9e1d506a8cfedef2fdd605e4cbf4bf53651ad214'

before "deploy:update_code", "deploy:pending:default" 
after  "deploy:update_code", "deploy:cleanup"
