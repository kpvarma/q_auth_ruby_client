$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "q_auth_ruby_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "q_auth_ruby_client"
  s.version     = QAuthRubyClient::VERSION
  s.authors     = ["Krishnaprasad Varma"]
  s.email       = ["krshnaprsad@gmail.com"]
  s.homepage    = "http://kpvarma.com"
  s.summary     = "QAuthRubyClient is a Q-Apps client engine"
  s.description = "QAuthRubyClient can be mounted into any Q-App to deal with all q-apps services like authentication"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.add_dependency "rails", '~> 4.1',">= 4.1.5"
  s.add_dependency "poodle-rb", '~> 0.1.0',">= 0.0.1"
  s.add_dependency "typhoeus", '~> 0.6',">= 0.6.9"
  s.add_development_dependency "sqlite3", '~> 1.3',">= 1.3.10"
end
