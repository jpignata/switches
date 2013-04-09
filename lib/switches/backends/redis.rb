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
      data = connection.get(key_for(item))

      if data
        JSON.parse(data)
      else
        {}
      end
    end

    def listen
      Thread.new { subscribe }
    end

    def notify(update)
      connection.publish(CHANNEL, update.to_json)
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
      listener.subscribe(NOTIFICATION_CHANNEL) do |on|
        on.message do |_, message|
          update = Update.parse(message)
          @instance.update_received(update) if update
        end
      end
    end

    def key_for(item)
      "#{item.class.to_s.downcase}:#{item.name}"
    end
  end
end
