require "redis"

module Backends
  class Redis
    PREFIX = "switches"
    CHANNEL = [PREFIX, "bus"].join(":")

    def initialize(uri, instance)
      @uri = uri
      @instance = instance
    end

    def set(item)
      connection.set(key_for(item), item.to_json)
    end

    def get(item)
      if data = connection.get(key_for(item))
        parse(data)
      end
    end

    def listen
      Thread.new { subscribe }
    end

    def notify(update)
      connection.publish(CHANNEL, update.to_json)
    end

    def clear
      connection.flushdb
    end

    private

    def listener
      @listener ||= connect
    end

    def connection
      @connection ||= connect
    end

    def connect
      ::Redis.new(url: @uri)
    end

    def subscribe
      listener.subscribe(CHANNEL) do |on|
        on.message { |_, message| process(message) }
      end
    end

    def key_for(item)
      [item.class.to_s.downcase, item.name].join(":")
    end

    def parse(json)
      JSON.parse(json.to_s)
    rescue JSON::ParserError
      {}
    end

    def process(message)
      attributes = parse(message)
      update = Update.new(attributes)

      @instance.notified(update)
    end
  end
end
