Gem::Specification.new do |s|
  s.name        = "feature_switches"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Pignata"]
  s.email       = ["john@pignata.com"]
  s.homepage    = "http://github.com/jpignata/switches"
  s.summary     = "Feature switches"
  s.description = "Feature switches for applications that run on multiple nodes that uses a not-very-chatty protocol"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("{lib}/**/*") + %w(README.md)
  s.require_path = "lib"
end
