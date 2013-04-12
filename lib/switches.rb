require "securerandom"
require "thread"
require "monitor"
require "json"
require "set"
require "zlib"
require "uri"

require "multi_json"

require "switches/json_serializer"
require "switches/configuration"
require "switches/instance"
require "switches/cohorts"
require "switches/cohort"
require "switches/features"
require "switches/feature"
require "switches/percentage"
require "switches/update"
require "switches/backend"
require "switches/backends/redis"
require "switches/backends/memory"
require "switches/backends/postgres"

Thread.abort_on_exception = true

def Switches
  configuration = Switches::Configuration.new
  yield configuration

  instance = Switches::Instance.new(configuration)
  instance.start
end
