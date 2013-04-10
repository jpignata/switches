require "securerandom"
require "thread"
require "monitor"
require "json"
require "set"
require "zlib"

require "switches/configuration"
require "switches/instance"
require "switches/cohorts"
require "switches/cohort"
require "switches/features"
require "switches/feature"
require "switches/percentage"
require "switches/update"
require "switches/backends/redis"
require "switches/backends/memory"
require "switches/backend"

Thread.abort_on_exception = true

def Switches
  configuration = Configuration.new
  yield configuration

  instance = Instance.new(configuration)
  instance.start
end
