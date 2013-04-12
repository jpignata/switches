module Switches
  module Backends
    class Memory < Backend
      class Bus
        def initialize
          @listeners = []
        end

        def subscribe(&block)
          @listeners << block
        end

        def publish(data)
          @listeners.each do |listener|
            listener.call(data)
          end
        end

        def clear
          @listeners.clear
        end
      end

      def self.bus
        @bus ||= Bus.new
      end

      def self.data
        @data ||= {}
      end

      def self.clear
        bus.clear
        data.clear
      end

      def initialize(uri, instance)
        @instance = instance
      end

      def set(item)
        data[item.key] = item.to_json
      end

      def get(item)
        if json = data[item.key]
          parse(json)
        end
      end

      def listen
        bus.subscribe do |update|
          process(update)
        end
      end

      def notify(update)
        bus.publish(update.to_json)
      end

      def clear
        self.class.clear
      end

      private

      def bus
        self.class.bus
      end

      def data
        self.class.data
      end
    end
  end
end
