$: << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "rspec"
require "switches"

ENV["DATABASE_URL"] ||= "postgres://root:@localhost/switches"
ENV["REDIS_URL"] ||= "redis://localhost:6379/15"

Thread.abort_on_exception = true

Dir["./spec/support/*.rb"].each do |support_helper|
  require support_helper
end
