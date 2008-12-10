Gem::Specification.new do |s|
  s.name     = "rexml-expansion-fix"
  s.version  = "1.0.1"
  s.date     = "2008-08-31"
  s.summary  = "Prevents potentitial DoS attacks to rexml"
  s.email    = "michael@koziarski.com"
  s.homepage = "http://github.com/NZKoz/rexml-expansion-fix"
  s.description = "Prevents DoS attacks using the billion-laughs or entity-explosion techniques."
  s.has_rdoc = false
  s.authors  = ["Michael Koziarski"]
  s.files    = ["README.textile", 
		"LICENSE",
		"example.xml", 
		"rexml-expansion-fix.gemspec", 
		"lib/rexml-expansion-fix.rb"]
end
