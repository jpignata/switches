require "pg"

module Switches
  module Backends
    class Postgres
      TABLE = "switches"

      def initialize(uri, instance)
        @uri = uri
        @instance = instance
      end

      def set(item)
        result = connection.exec("UPDATE #{TABLE} SET value = $1 WHERE key = $2",
          [item.to_json, item.key]
        )

        if result.cmd_tuples == 0
          connection.exec("INSERT INTO #{TABLE} (key, value) values($1, $2)",
            [item.key, item.to_json]
          )
        end
      end

      def get(item)
        result = connection.exec("SELECT value FROM #{TABLE} WHERE key = $1 LIMIT 1",
          [item.key]
        )

        result.each do |row|
          return JSONSerializer.deserialize(row["value"])
        end

        nil
      end

      def listen
        Thread.new { subscribe }
      end

      def notify(update)
        connection.exec("NOTIFY #{TABLE}, '#{update.to_json}'")
      end

      def clear
        connection.exec("TRUNCATE TABLE #{TABLE}")
      end

      private

      def listener
        @listener ||= connect
      end

      def connection
        @connection ||= connect
      end

      def connect
        PG.connect(connection_options)
      end

      def connection_options
        {
          user:     @uri.user,
          password: @uri.password,
          host:     @uri.host,
          port:     @uri.port,
          dbname:   @uri.path[1..-1]
        }
      end

      def subscribe
        loop do
          listener.exec("LISTEN #{TABLE}")
          listener.wait_for_notify do |event, pid, message|
            update = Update.load(message)
            @instance.notified(update)
          end
        end
      end
    end
  end
end
