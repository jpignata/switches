module Switches
  class Backend
    def self.factory(url, instance)
      uri = URI(url)

      if uri.scheme == "redis"
        require "switches/backends/redis"
        Backends::Redis.new(uri, instance)
      elsif uri.scheme == "postgres"
        require "switches/backends/postgres"
        Backends::Postgres.new(uri, instance)
      else
        require "switches/backends/memory"
        Backends::Memory.new(uri, instance)
      end
    end
  end
end
