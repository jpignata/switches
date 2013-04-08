require "spec_helper"

describe Configuration do
  describe ".new" do
    it "yields the given block to the new instance" do
      instance = nil

      configuration = Configuration.new do |config|
        instance = config
      end

      instance.should eq(configuration)
    end
  end
end
