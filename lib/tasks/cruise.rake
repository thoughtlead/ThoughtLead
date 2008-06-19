task :cruise => %w(testing db:migrate:reset test cap_staging_deploy)

task :cap_staging_deploy => :environment  do
  `cap staging deploy`
end
