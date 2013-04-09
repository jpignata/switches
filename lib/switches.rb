require "securerandom"
require "thread"
require "json"
require "redis"

require "switches/configuration"
require "switches/instance"
require "switches/feature"
require "switches/backend"
require "switches/backends/redis"
require "switches/backends/memory"
require "switches/update"

def Switches
  configuration = Configuration.new
  yield configuration
  Instance.new(configuration)
end
