module Switches
  class Update
    attr_accessor :type, :name, :node_id

    def initialize(attributes = {})
      @type = attributes["type"]
      @name = attributes["name"]
      @node_id = attributes["node_id"]
    end

    def from?(node_id)
      @node_id == node_id
    end

    def to_json
      {
        "type" => type,
        "name" => name,
        "node_id" => node_id
      }.to_json
    end
  end
end
