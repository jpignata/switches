module Switches
  class Instance
    include MonitorMixin

    attr_reader :node_id

    def initialize(configuration)
      @url = configuration.backend
      @node_id = SecureRandom.hex(3)

      mon_initialize
    end

    def start
      backend.listen
      self
    end

    def stop
      backend.stop
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
      update = Update.build(item, node_id)
      backend.notify(update)
    end

    def notified(update)
      unless update.from?(node_id)
        collections[update.type].reload(update.name)
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
      @features ||= Feature.collection(self)
    end

    def cohorts
      @cohorts ||= Cohort.collection(self)
    end

    def collections
      {
        "feature" => features,
        "cohort" => cohorts
      }
    end
  end
end
