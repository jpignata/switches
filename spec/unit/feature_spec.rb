require "spec_helper"

describe Feature do
  let(:instance) { stub(set: true, notify: true) }

  let(:feature) { Feature.new(:redesign, instance) }

  describe "#on" do
    it "turns the feature on" do
      feature.should_not be_on
      feature.on
      feature.should be_on
    end

    context "with a percentage" do
      it "turns the feature on to that percentage" do
        feature.should_not be_on
        feature.on(25)
        feature.should be_on
        feature.percentage.should eq(25)
      end
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

  describe "#inspect" do
    context "the feature has not been turned on" do
      it "indicates the feature is off" do
        feature.inspect.should eq("#<Feature name:redesign off>")
      end
    end

    context "the feature has been turned on" do
      it "indicates the feature is on" do
        feature.on
        feature.inspect.should eq("#<Feature name:redesign on>")
      end
    end

    context "the feature has been turned on to a percentage" do
      it "includes the percentage" do
        feature.on(33)
        feature.inspect.should eq("#<Feature name:redesign on:33>")
      end
    end
  end
end
