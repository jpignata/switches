Gem::Specification.new do |s|
  s.name        = "feature_switches"
  s.version     = "0.2.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Pignata"]
  s.email       = ["john@pignata.com"]
  s.homepage    = "http://github.com/jpignata/switches"
  s.summary     = "Feature switches"
  s.description = "Feature switches for applications that run on multiple nodes that uses a not-very-chatty protocol"
  s.license  = "MIT"

  s.add_dependency "multi_json", "~> 1.7.2"
  s.add_development_dependency "rspec", "~> 2.13.0"

  s.files        = Dir.glob("{lib}/**/*") + %w(README.md LICENSE)
  s.require_path = "lib"
end
