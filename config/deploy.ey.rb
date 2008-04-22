# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com

require "eycap/recipes"
#require "spacesuit/recipes"

# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The :deploy_to variable must be the root of the application.

set :keep_releases,       10
set :application,         "thoughtlead"
set :repository,          "git@github.com:duff/thoughtlead.git"
set :scm,                 :git
set :branch,              "origin/master"
set :rails_env,           "production"
set :client,              "verticality"
set :domain,              "#{application}.#{client}.dock.terralien.biz"
set :svn_username,        "duff"
set :rails_revision,      "9e1d506a8cfedef2fdd605e4cbf4bf53651ad214"
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

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

default_run_options[:pty] = true

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

task :production do
  role :web, "74.201.254.36:8118" # thoughtlead [mongrel] [mysql50-6-master,mysql50-staging-1]
  role :app, "74.201.254.36:8118", :mongrel => true
  role :db , "74.201.254.36:8118", :primary => true
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end
  
task :staging do
  before "deploy:update_code", "deploy:pending:default" 
  after "deploy:migrations" , "deploy:cleanup"
  set :deploy_to, "/var/www/#{client}/#{application}"

  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
end

# =============================================================================
# Any custom after tasks can go here.
# after "deploy:symlink_configs", "thoughtlead_custom"
# task :thoughtlead_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
#   run <<-CMD
#   CMD
# end
# =============================================================================

# Do not change below unless you know what you are doing!

after "deploy", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"
