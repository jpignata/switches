require "spec_helper"

describe Switches::Instance do
  let(:configuration) do
    Switches::Configuration.new do |config|
      config.backend = "memory:///"
    end
  end

  let(:backend) { stub }

  let(:instance) { Switches::Instance.new(configuration) }

  before do
    Switches::Backend.stub(factory: backend)
  end

  describe ".new" do
    it "initializes the monitor" do
      expect {
        instance.synchronize { "testing" }
      }.not_to raise_exception
    end

    it "assigns a random node_id of 6 hex characters" do
      instance.node_id.should match(/\w{6}/)
    end
  end

  describe "#start" do
    before do
      backend.stub(:listen)
    end

    it "starts listening on the backend" do
      backend.should_receive(:listen)
      instance.start
    end

    it "returns the instance" do
      instance.start.should eq(instance)
    end
  end

  describe "#feature" do
    context "the feature doesn't exist" do
      before do
        backend.should_receive(:get).and_return(nil)
      end

      it "returns a new feature" do
        instance.feature(:redesign).should be_an_instance_of(Switches::Feature)
      end
    end

    context "the feature exists" do
      let(:attributes) do
        { "name" => "redesign", "cohorts" => [] }
      end

      before do
        backend.should_receive(:get).and_return(attributes)
      end

      it "returns the feature" do
        feature = instance.feature(:redesign)
        feature.name.should eq(:redesign)
      end
    end
  end

  describe "#cohort" do
    context "the cohort doesn't exist" do
      before do
        backend.should_receive(:get).and_return(nil)
      end

      it "returns a new cohort" do
        instance.cohort(:power_users).should be_an_instance_of(Switches::Cohort)
      end
    end

    context "the cohort exists" do
      let(:attributes) do
        { "name" => "power_users", "members" => [] }
      end

      before do
        backend.should_receive(:get).and_return(attributes)
      end

      it "returns the cohort" do
        cohort = instance.cohort(:power_users)
        cohort.name.should eq(:power_users)
      end
    end
  end

  describe "#get" do
    it "gets an item's attributes from the backend" do
      item = stub
      backend.should_receive(:get).with(item)
      instance.get(item)
    end
  end

  describe "#set" do
    it "sets an item's attributes in the backend" do
      item = stub
      backend.should_receive(:set).with(item)
      instance.set(item)
    end
  end

  describe "#notify" do
    it "builds an update and notifies the backend" do
      item = stub(name: "redesign", type: "feature")
      backend.should_receive(:notify) do |update|
        update.name.should eq("redesign")
        update.type.should eq("feature")
        update.node_id.should eq(instance.node_id)
      end

      instance.notify(item)
    end
  end

  describe "#notified" do
    it "reloads the updated item" do
      update = Switches::Update.new(
        "name" => "redesign",
        "type" => "feature",
        "node_id" => "abc123"
      )

      feature = stub
      feature.should_receive(:reload)

      Switches::Feature.
        should_receive(:new).
        with(:redesign, anything).
        and_return(feature)

      instance.notified(update)
    end

    context "the update is from the current node" do
      it "ignores the update" do
        item = stub(name: "redesign", type: "feature")
        update = Switches::Update.build(item, instance.node_id)
        backend.should_not_receive(:notify)
        instance.notified(update)
      end
    end
  end

  describe "#clear" do
    it "clears data from the backend" do
      backend.should_receive(:clear)
      instance.clear
    end
  end

  describe "#inspect" do
    it "returns human readable output which includes the backend URL" do
      instance.inspect.should eq("#<Switches memory:///>")
    end
  end
end
