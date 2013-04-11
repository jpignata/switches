require "uri"

class Backend
  def self.factory(url, instance)
    uri = URI(url)

    if uri.scheme == "redis"
      Backends::Redis.new(uri, instance)
    else
      Backends::Memory.new(uri, instance)
    end
  end
end
