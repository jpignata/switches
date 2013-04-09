class Update
  attr_accessor :type, :name, :node_id

  def self.parse(update)
    attributes = JSON.parse(update)

    update = new
    update.type = attributes["type"].to_sym
    update.name = attributes["name"].to_sym
    update.node_id = attributes["node_id"]
    update
  end

  def to_json
    JSON.generate(
      type: type,
      name: name,
      node_id: node_id
    )
  end
end
