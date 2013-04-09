require "uri"
class Backend
  def self.factory(url, instance)
    uri = URI(url)

    case uri.scheme
    when "redis"
      Backends::Redis.new(uri, instance)
    when "memory"
      Backends::Memory.new(uri, instance)
    end
  end
end
