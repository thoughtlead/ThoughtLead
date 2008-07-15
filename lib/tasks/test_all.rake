namespace :test do
  desc "Run all tests, including watir"
  task :all do
    Rake::Task["test"].invoke
    Rake::Task["test:watir"].invoke
  end 
end
