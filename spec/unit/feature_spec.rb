require "spec_helper"

describe Feature do
  let(:instance) { stub(set: true, notify: true) }

  let(:feature) { Feature.new(:redesign, instance) }

  describe "#on" do
    it "turns the feature on to 100 percent" do
      feature.percentage.should eq(Percentage(0))
      feature.on
      feature.percentage.should eq(Percentage(100))
    end

    context "with a percentage" do
      it "turns the feature on to that percentage" do
        feature.percentage.should eq(Percentage(0))
        feature.on(25)
        feature.percentage.should eq(Percentage(25))
      end
    end
  end

  describe "#inspect" do
    context "the feature has not been turned on" do
      it "indicates the feature is set to 0 percent" do
        feature.inspect.should eq("#<Feature redesign; 0%>")
      end
    end

    context "the feature has been turned on" do
      it "indicates the feature is set to 100 percent" do
        feature.on
        feature.inspect.should eq("#<Feature redesign; 100%>")
      end
    end

    context "the feature has been turned on to a percentage" do
      it "includes the percentage" do
        feature.on(33)
        feature.inspect.should eq("#<Feature redesign; 33%>")
      end
    end
  end
end
