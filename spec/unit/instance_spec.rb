require "spec_helper"

describe Switches::Instance do
  let(:configuration) do
    Switches::Configuration.new do |config|
      config.backend = "memory:///"
    end
  end

  let(:instance) { Switches::Instance.new(configuration) }

  describe "#feature" do
    it "returns a new feature" do
      instance.feature(:redesign).should be_an_instance_of(Switches::Feature)
    end
  end
end
