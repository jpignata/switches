class Features
  def initialize(instance)
    @features ||= Hash.new do |features, name|
      name = name.to_sym
      features[name] = Feature.new(name, instance).reload
    end
  end

  def [](name)
    @features[name.to_sym]
  end
end
