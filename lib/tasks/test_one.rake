namespace :test do
  desc "Run a test as set by TEST_NAME="
  Rake::TestTask.new(:one => "db:test:prepare") do |t|
    test = ""
    test = ENV["TEST_NAME"] if ENV["TEST_NAME"]
    t.libs << "test"
    t.pattern = 'test/**/' + test + '_test.rb'
    t.verbose = true
  end  
end
