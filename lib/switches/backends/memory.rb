module Backends
  class Memory
    def initialize(uri, instance)
      @instance = instance
      @data = {}
    end

    def set(name, item)
      @data[name] = item
    end

    def get(item)
      @data[item.name]
    end

    def listen
    end

    def notify(update)
    end
  end
end
