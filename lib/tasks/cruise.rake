task :cruise => %w(testing db:migrate:reset test cap_staging_deploy staging ultrasphinx:display_configuration ultrasphinx:configure ultrasphinx:index ultrasphinx:daemon:restart)

task :cap_staging_deploy => :environment  do
  `cap staging deploy`
  raise "Error deploying to staging" if $?.exitstatus == 1
  `cap staging deploy:migrate`
  raise "Error migrating staging database" if $?.exitstatus == 1
end
