module Switches
  module Backends
    class Memory
      def initialize(uri, instance)
        @instance = instance
        $switches_data ||= {}
        $switches_listeners ||= Set.new
      end

      def set(item)
        $switches_data[key_for(item)] = item.to_json
      end

      def get(item)
        if data = $switches_data[key_for(item)]
          parse(data)
        end
      end

      def listen
        $switches_listeners.add(@instance)
      end

      def notify(update)
        $switches_listeners.each do |listener|
          listener.notified(update)
        end
      end

      def clear
        $switches_data.clear
        $switches_listeners.clear
      end

      private

      def key_for(item)
        [item.class.to_s.downcase, item.name].join(":")
      end

      def parse(json)
        JSON.parse(json.to_s)
      rescue JSON::ParserError
        {}
      end
    end
  end
end
