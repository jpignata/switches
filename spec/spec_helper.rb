require "english"

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))

require "rspec"
require "switches"

RSpec.configure do |config|
  config.before(:each) do
    r = Redis.new
    r.select 11
    r.flushdb
  end
end

Thread.abort_on_exception = true
