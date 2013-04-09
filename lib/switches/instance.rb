class Instance
  attr_reader :node_id

  def initialize(configuration)
    @configuration = configuration
    @features = {}
    @cohorts = {}
    @mutex = Mutex.new
    @node_id = SecureRandom.hex(5)

    backend.listen
  end

  def feature(name)
    @mutex.synchronize do
      @features[name] ||= Feature.new(name, self).reload
    end
  end

  def cohort(name)
    @mutex.synchronize do
      @cohort[name] ||= Cohort.new(name, self).reload
    end
  end

  def get(item)
    backend.get(item)
  end

  def set(item)
    backend.set(item)
  end

  def notify(item)
    update = Update.new
    update.type = item.class.to_s
    update.name = item.name
    update.node_id = node_id

    @backend.notify(update)
  end

  def update_received(update)
    return if update.node_id == node_id

    @mutex.synchronize do
      @features[update.name] = feature(update.name).reload
    end
  end

  private

  def backend
    @backend ||= Backend.factory(@configuration.backend, self)
  end
end
