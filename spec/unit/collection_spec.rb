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
end
