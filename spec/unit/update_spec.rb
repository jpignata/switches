require "spec_helper"

describe Switches::Update do
  describe ".build" do
    it "returns a new update from a given item and node_id" do
      item = stub(type: "feature", name: "redesign")
      node_id = "abc123"

      update = Switches::Update.build(item, node_id)
      update.type.should eq("feature")
      update.name.should eq("redesign")
      update.node_id.should eq("abc123")
    end
  end

  describe ".load" do
    it "deserializes the given json uses it to build an update" do
      json = '{"type":"feature","name":"redesign","node_id":"abc123"}'

      update = Switches::Update.load(json)
      update.type.should eq("feature")
      update.name.should eq("redesign")
      update.node_id.should eq("abc123")
    end
  end
end
