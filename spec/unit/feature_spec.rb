require "spec_helper"

describe Feature do
  let(:feature) { Feature.new(:redesign) }

  describe "#on" do
    it "turns the feature on" do
      feature.should_not be_on
      feature.on
      feature.should be_on
    end
  end

  describe "#on?" do
    context "the feature has been turned on" do
      it "returns true" do
        feature.on
        feature.should be_on
      end
    end

    context "the feature has not been turned on" do
      it "returns false if the feature hasn't been turned on" do
        feature.should_not be_on
      end
    end
  end
end
