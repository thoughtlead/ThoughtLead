set :domain,          "gukumatz.tsi.local"
set :rails_env,       "staging"
set :deploy_to,       "/var/www/apps/#{application}"
set :monit_group,     "verticality"
set :deploy_via, :filtered_remote_cache

role :web, domain
role :app, domain
role :db,  domain, :primary => true
