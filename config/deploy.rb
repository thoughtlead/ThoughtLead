require 'capistrano/ext/multistage'
require "eycap/recipes"

set :keep_releases,       20
set :application,         "thoughtlead"
set :repository,          "git@github.com:wideopenspaces/thoughtlead.git"
set :scm,                 :git
set :user,                "verticality"
set :runner,              "verticality"

ssh_options[:paranoid] = false
default_run_options[:pty] = true

after "deploy:update_code", "deploy:symlink_configs"
after "deploy:symlink", "deploy:link_shared_stuff"
