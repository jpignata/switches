class Configuration
  attr_accessor :backend

  def initialize
    yield self if block_given?
  end
end
