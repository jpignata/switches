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
require "switches/collection"
require "switches/instance"
require "switches/cohort"
require "switches/feature"
require "switches/percentage"
require "switches/update"
require "switches/backend"

def Switches(&block)
  configuration = Switches::Configuration.new(&block)
  instance = Switches::Instance.new(configuration)

  instance.start
end
