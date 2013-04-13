require "pg"
require "switches/backends/postgres/connection"
require "switches/backends/postgres/table"

module Switches
  module Backends
    class Postgres
      CHANNEL = "switches"
      TABLE = "switches"

      def initialize(uri, instance)
        @uri = uri
        @instance = instance
      end

      def set(item)
        table.upsert(item.key, item.to_json)
      end

      def get(item)
        if result = table.find(item.key)
          JSONSerializer.deserialize(result)
        end
      end

      def listen
        @thread ||= Thread.new { subscribe }
      end

      def notify(update)
        connection.notify(CHANNEL, update.to_json)
      end

      def clear
        table.clear
      end

      def stop
        listen.kill
        listener.close
        connection.close
      end

      private

      def listener
        @listener ||= Connection.new(@uri)
      end

      def connection
        @connection ||= Connection.new(@uri)
      end

      def table
        @table ||= Table.new(TABLE, connection)
      end

      def subscribe
        listener.listen(CHANNEL) do |message|
          update = Update.load(message)
          @instance.notified(update)
        end
      end
    end
  end
end
