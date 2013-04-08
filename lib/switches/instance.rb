class Instance
  def initialize(configuration)
    @configuration = configuration
    @features = {}
  end

  def feature(name)
    @features[name] ||= Feature.new(name)
  end
end
