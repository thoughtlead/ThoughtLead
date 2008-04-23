require 'capistrano/ext/multistage'
require "eycap/recipes"

set :keep_releases,       20
set :application,         "thoughtlead"
set :repository,          "git@github.com:duff/thoughtlead.git"
set :scm,                 :git
set :branch,              "origin/master"
set :user,                "verticality"
set :deploy_via,          :remote_cache

set :rails_revision,      "9e1d506a8cfedef2fdd605e4cbf4bf53651ad214"

ssh_options[:paranoid] = false
default_run_options[:pty] = true

before "deploy:update_code", "deploy:pending:default" 
after "deploy", "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"
after "deploy:symlink", "deploy:link_shared_stuff"
