require "english"

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "rspec"
require "switches"

ENV["DATABASE_URL"] ||= "postgres://root:@localhost/switches"

Dir["./spec/support/*.rb"].each do |support_helper|
  require support_helper
end
