class Instance
  include MonitorMixin

  attr_reader :node_id

  def initialize(configuration)
    @url     = configuration.backend
    @node_id = SecureRandom.hex(3)

    mon_initialize
  end

  def start
    backend.listen
    self
  end

  def feature(name)
    synchronize do
      features[name]
    end
  end

  def cohort(name)
    synchronize do
      cohorts[name]
    end
  end

  def get(item)
    backend.get(item)
  end

  def set(item)
    backend.set(item)
  end

  def notify(item)
    Update.new.tap do |update|
      update.type = item.class.to_s
      update.name = item.name
      update.node_id = node_id

      backend.notify(update)
    end
  end

  def notified(update)
    return if update.from?(node_id)

    case update.type
    when "Feature"
      synchronize do
        features[update.name].reload
      end
    when "Cohort"
      synchronize do
        cohorts[update.name].reload
      end
    end
  end

  def clear
    backend.clear
  end

  def inspect
    "#<Switches #{@url}>"
  end

  private

  def backend
    @backend ||= Backend.factory(@url, self)
  end

  def features
    @features ||= Features.new(self)
  end

  def cohorts
    @cohorts ||= Cohorts.new(self)
  end
end
