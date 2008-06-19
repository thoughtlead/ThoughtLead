task :cruise => %w(testing db:migrate:reset test cap_staging_deploy)

task :cap_staging_deploy => :environment  do
  `cap staging deploy`
  raise "Error deploying to staging" if $?.exitstatus == 1
end
