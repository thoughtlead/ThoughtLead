# from http://errtheblog.com/posts/31-rake-around-the-rosie

%w[development production staging test].each do |environment|
  desc "Runs the following task in the #{environment} environment"
  task environment do
    RAILS_ENV = ENV['RAILS_ENV'] = environment
  end
end

task :testing do
  Rake::Task["test"].invoke
end

task :dev do
  Rake::Task["development"].invoke
end

task :prod do
  Rake::Task["production"].invoke
end
