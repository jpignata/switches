require "spec_helper"

describe Instance do
  let(:configuration) do
    Configuration.new do |config|
      config.backend = "memory:///"
    end
  end

  let(:instance) { Instance.new(configuration) }

  describe "#feature" do
    it "returns a new feature" do
      instance.feature(:redesign).should be_an_instance_of(Feature)
    end
  end
end
