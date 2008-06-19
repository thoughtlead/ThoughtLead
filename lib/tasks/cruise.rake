task :cruise => %w(testing db:migrate:reset test)

task :cap_deploy => :environment  do
  require 'capistrano/cli'
  Capistrano::CLI.parse(%w(staging deploy)).execute!
end