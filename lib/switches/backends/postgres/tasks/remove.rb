module Switches
  module Backends
    class Postgres
      class Remove
        def initialize(connection)
          @connection = connection
        end

        def run
          drop_table
        end

        private

        def drop_table
          @connection.execute("DROP TABLE switches")
        end
      end
    end
  end
end
