require "spec_helper"

describe Switches::Collection do
  let(:item) { stub(reload: true) }

  let(:klass) { stub(new: item) }

  let(:instance) { stub }

  let(:collection) { Switches::Collection.new(klass, instance) }

  describe "#[]" do
    context "item is found" do
      it "returns the item" do
        collection["thing"].should eq(item)
      end
    end

    context "item is not found" do
      it "creates a new instance passing the symbolized name and the instance" do
        klass.
          should_receive(:new).
          with(:thing, instance).
          and_return(item)

        collection["thing"]
      end
    end
  end

  describe "#reload" do
    context "the item exists in the collection" do
      it "reloads the item" do
        collection[:thing].should be
        item.should_receive(:reload)
        collection.reload(:thing)
      end
    end

    context "the item does not exist in the collection" do
      it "loads the item once and doesn't call reload again" do
        item.should_receive(:reload)
        collection.reload(:thing)
      end
    end
  end

  describe "#include?" do
    it "returns true if the item is in the collection" do
      collection[:thing].should be
      collection.should include(:thing)
    end

    it "returns false if the item is not in the collection" do
      collection.should_not include(:thing)
    end
  end
end
