module Switches
  module Backends
    class Memory
      class Bus
        def initialize
          @listeners = []
        end

        def subscribe(&block)
          @listeners.push(block)
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
    end
  end
end
