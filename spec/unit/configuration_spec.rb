require "spec_helper"

describe Switches::Configuration do
  describe ".new" do
    it "yields the given block to the new instance" do
      configuration = Switches::Configuration.new do |config|
        config.freeze
      end

      configuration.should be_frozen
    end
  end
end
