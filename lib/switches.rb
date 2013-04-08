require "switches/configuration"
require "switches/instance"
require "switches/feature"

def Switches
  configuration = Configuration.new
  yield configuration
  Instance.new(configuration)
end
