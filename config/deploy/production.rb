
role :web, "74.201.254.36:8118" # thoughtlead [mongrel] [mysql50-6-master,mysql50-staging-1]
role :app, "74.201.254.36:8118", :mongrel => true, :sphinx => true
role :db , "74.201.254.36:8118", :primary => true
set :rails_env, "production"

set :environment_database, defer { production_database }
set :environment_dbhost, defer { production_dbhost }
set :deploy_to, "/data/#{application}"
set :repository_cache,    "/var/cache/engineyard/#{application}"
set :monit_group,         "thoughtlead"
set :production_database, "thoughtlead_production"
set :production_dbhost,   "mysql50-6-master"
set :staging_database,    "thoughtlead_staging"
set :staging_dbhost,      "mysql50-staging-1"
set :dbuser,              "verticality_db"
set :dbpass,              "2b1i2h1v"
set :password,            "be2k1v12"
set :domain,              "thoughtlead.com"

after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

#
# ADDED FOR SPHINX:
#
after "deploy:symlink_configs", "sphinx:symlink"
after "deploy:symlink", "sphinx:configure"
after "sphinx:configure", "sphinx:reindex"
after "sphinx:reindex", "sphinx:restart"