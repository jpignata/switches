module Switches
  module JSONSerializer
    ParserError = Class.new(MultiJson::LoadError)

    def as_json
      raise NotImplementedError
    end

    def to_json
      serialize(as_json)
    end

    module_function

    def serialize(object)
      MultiJson.dump(object)
    end

    def deserialize(json)
      MultiJson.load(json)
    rescue Exception => e
      raise ParserError
    end
  end
end
