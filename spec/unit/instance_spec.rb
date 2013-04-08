require "spec_helper"

describe Instance do
  let(:instance) { Instance.new(stub) }

  describe "#feature" do
    it "returns a new feature" do
      instance.feature(:redesign).should be_an_instance_of(Feature)
    end
  end
end
