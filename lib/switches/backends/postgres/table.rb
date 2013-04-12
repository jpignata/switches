module Switches
  module Backends
    class Postgres
      class Table
        UPDATE = "UPDATE %s SET value = $1 WHERE key = $2"
        INSERT = "INSERT INTO %s (key, value) values($2, $1)"
        SELECT = "SELECT value FROM %s WHERE key = $1 LIMIT 1"

        def initialize(name, connection)
          @name = name
          @connection = connection
        end

        def upsert(key, value)
          result = @connection.execute(UPDATE % @name, value, key)

          if result.cmd_tuples == 0
            @connection.execute(INSERT % @name, value, key)
          end
        end

        def find(key)
          result = @connection.execute(SELECT % @name, key)

          result.each do |row|
            return row["value"]
          end

          nil
        end

        def clear
          @connection.execute("TRUNCATE TABLE #{@name}")
        end
      end
    end
  end
end
