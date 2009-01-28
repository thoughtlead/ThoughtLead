# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ssl_requirement}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["RailsJedi", "David Heinemeier Hansson"]
  s.date = %q{2008-12-30}
  s.description = %q{SSL requirement adds a declarative way of specifying that certain actions should only be allowed to run under SSL, and if they're accessed without it, they should be redirected.}
  s.email = %q{railsjedi@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["VERSION.yml", "lib/ssl_requirement.rb", "lib/url_rewriter.rb", "test/ssl_requirement_test.rb", "test/url_rewriter_test.rb", "README"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tbmcmullen/ssl_requirement}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Allow controller actions to force SSL on specific parts of the site.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 2.1"])
    else
      s.add_dependency(%q<rails>, [">= 2.1"])
    end
  else
    s.add_dependency(%q<rails>, [">= 2.1"])
  end
end
