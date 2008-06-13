require "spacesuit/recipes/common"
require 'capistrano/ext/multistage'
require "eycap/recipes"


set :keep_releases,       20
set :application,         "thoughtlead"
set :repository,          "git@github.com:Ternary/thoughtlead.git"
set :scm,                 :git
# set :branch,              "origin/master"
set :user,                "verticality"
set :runner,              "verticality"

set :rails_revision,      "888a2927b65889465ce7a1a71e87d37640a2b41b"

ssh_options[:paranoid] = false
default_run_options[:pty] = true

before "deploy:update_code", "deploy:git:pending" 
after "deploy:update_code", "deploy:symlink_configs"
after "deploy:symlink", "deploy:link_shared_stuff"

