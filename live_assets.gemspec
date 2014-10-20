$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "live_assets/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "live_assets"
  s.version     = LiveAssets::VERSION
  s.authors     = ["Sergii Brytiuk"]
  s.email       = ["brytiuk@ukr.net"]
  s.homepage    = "https://github.com/645383/live_assets"
  s.summary     = "No need to reload the page when css changed"
  s.description = "Streaming changes in css"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "puma"
  s.add_dependency "listen"
end
