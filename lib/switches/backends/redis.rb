require "redis"

module Switches
  module Backends
    class Redis < Backend
      PREFIX = "switches"
      CHANNEL = [PREFIX, "bus"].join(":")

      def initialize(uri, instance)
        @uri = uri
        @instance = instance
      end

      def set(item)
        connection.set(item.key, item.to_json)
      end

      def get(item)
        if data = connection.get(item.key)
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
    end
  end
end
