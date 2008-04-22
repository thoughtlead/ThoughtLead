require "eycap/recipes"

set :keep_releases,       20
set :application,         "thoughtlead"
set :repository,          "git@github.com:duff/thoughtlead.git"
set :scm,                 :git
set :branch,              "origin/master"
set :user,                "verticality"
set :password,            "be2k1v12"
set :deploy_to,           "/data/#{application}"
set :deploy_via,          :remote_cache
set :repository_cache,    "/var/cache/engineyard/#{application}"
set :monit_group,         "thoughtlead"
set :production_database, "thoughtlead_production"
set :production_dbhost,   "mysql50-6-master"
set :staging_database,    "thoughtlead_staging"
set :staging_dbhost,      "mysql50-staging-1"
set :dbuser,              "verticality_db"
set :dbpass,              "2b1i2h1v"

set :rails_revision,      "9e1d506a8cfedef2fdd605e4cbf4bf53651ad214"

ssh_options[:paranoid] = false
default_run_options[:pty] = true

task :production do
  role :web, "74.201.254.36:8118" # thoughtlead [mongrel] [mysql50-6-master,mysql50-staging-1]
  role :app, "74.201.254.36:8118", :mongrel => true
  role :db , "74.201.254.36:8118", :primary => true
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end
  
task :staging do
  require "spacesuit/recipes"
  
  set :client,          "verticality"
  set :domain,          "#{application}.#{client}.dock.terralien.biz"
  set :rails_env,       "staging"
  set :deploy_to,       "/var/www/#{client}/#{application}"

  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
end


before "deploy:update_code", "deploy:pending:default" 
after "deploy", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

