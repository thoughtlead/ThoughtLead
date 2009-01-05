set :domain,          "gukumatz.tsi.local"
set :rails_env,       "staging"
set :deploy_to,       "/var/www/apps/#{application}"
set :monit_group,     "verticality"
set :deploy_via, :remote_cache
set :branch, "master"

role :web, domain
role :app, domain
role :db,  domain, :primary => true
