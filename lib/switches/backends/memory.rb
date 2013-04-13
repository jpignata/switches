require "switches/backends/memory/bus"

module Switches
  module Backends
    class Memory
      def self.bus
        @bus ||= Bus.new
      end

      def self.storage
        @storage ||= {}
      end

      def self.clear
        bus.clear
        storage.clear
      end

      def initialize(uri, instance)
        @instance = instance
      end

      def set(item)
        self.class.storage[item.key] = item.to_json
      end

      def get(item)
        if json = self.class.storage[item.key]
          JSONSerializer.deserialize(json)
        end
      end

      def listen
        self.class.bus.subscribe do |message|
          update = Update.load(message)
          @instance.notified(update)
        end
      end

      def notify(update)
        self.class.bus.publish(update.to_json)
      end

      def clear
        self.class.clear
      end

      def stop
      end
    end
  end
end
