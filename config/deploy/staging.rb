require "spacesuit/recipes"

set :client,          "verticality"
set :domain,          "#{application}.#{client}.dock.terralien.biz"
set :rails_env,       "staging"
set :deploy_to,       "/var/www/#{client}/#{application}"

role :web, domain
role :app, domain
role :db,  domain, :primary => true
