begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'ssl_requirement'
    s.date = '2008-07-04'

    s.summary = "Allow controller actions to force SSL on specific parts of the site."
    s.description = "SSL requirement adds a declarative way of specifying that certain actions should only be allowed to run under SSL, and if they're accessed without it, they should be redirected."

    s.authors = ['RailsJedi', 'David Heinemeier Hansson']
    s.email = 'railsjedi@gmail.com'
    s.homepage = 'http://github.com/tbmcmullen/ssl_requirement'

    s.has_rdoc = true
    s.rdoc_options = ["--main", "README"]
    s.extra_rdoc_files = ["README"]

    s.add_dependency 'rails', ['>= 2.1']

    s.files = FileList["[A-Z]*.*", "{lib,test}/**/*"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
