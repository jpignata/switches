module Switches
  module Backends
    class Postgres
      class Setup
        def initialize(connection)
          @connection = connection
        end

        def run
          create_table
          create_index
        end

        private

        def create_table
          @connection.execute("CREATE TABLE switches (key varchar, value text)")
        end

        def create_index
          @connection.execute("CREATE UNIQUE INDEX switches_key ON switches (key)")
        end
      end
    end
  end
end
