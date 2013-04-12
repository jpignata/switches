module Switches
  class Backend
    def self.factory(url, instance)
      uri = URI(url)

      if uri.scheme == "redis"
        Backends::Redis.new(uri, instance)
      elsif uri.scheme == "postgres"
        Backends::Postgres.new(uri, instance)
      else
        Backends::Memory.new(uri, instance)
      end
    end

    def key_for(item)
      [item.type, item.name].join(":")
    end

    def parse(json)
      JSONSerializer.deserialize(json)
    rescue JSONSerializer::ParserError
      {}
    end

    def process(message)
      attributes = parse(message)
      update = Update.new(attributes)

      @instance.notified(update)
    end
  end
end
