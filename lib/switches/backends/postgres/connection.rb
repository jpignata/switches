module Switches
  module Backends
    class Postgres
      class Connection
        def initialize(uri)
          @uri = URI(uri)
        end

        def execute(query, *args)
          connection.exec(query, args)
        end

        def listen(channel)
          connection.exec("LISTEN #{channel}")

          loop do
            connection.wait_for_notify do |event, pid, message|
              yield message
            end
          end
        end

        def notify(channel, payload)
          connection.exec("NOTIFY #{channel}, '#{payload}'")
        end

        private

        def connection
          @connection ||= PG.connect(connection_options)
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
      end
    end
  end
end
