require "spec_helper"

describe Switches::Percentage do
  describe ".new" do
    it "sets the percentage's value to the given numeric" do
      Switches::Percentage.new(10).to_i.should eq(10)
    end

    context "a value less than 0" do
      it "sets the percentage's value to 0" do
        Switches::Percentage.new(-10).to_i.should eq(0)
      end
    end

    context "a value greater than 100" do
      it "sets the percentage's value to 100" do
        Switches::Percentage.new(999).to_i.should eq(100)
      end
    end

    context "a String" do
      it "sets the percentage's value to 0" do
        Switches::Percentage.new("one").to_i.should eq(0)
      end
    end

    context "nil" do
      it "sets the percentage's value to 0" do
        Switches::Percentage.new(nil).to_i.should eq(0)
      end
    end

    context "a Float" do
      it "coerces it to the Fixnum" do
        Switches::Percentage.new(1.4).to_i.should eq(1)
      end
    end
  end

  describe "#include?" do
    context "the given identifier is within the percentage" do
      it "returns true" do
        Percentage(100).should include("thing")
      end
    end

    context "the given identifier is not within the percentage" do
      it "returns false" do
        Percentage(0).should_not include("thing")
      end
    end

    it "coerces all input into a String" do
      percentage = Percentage(100)

      percentage.should include(nil)
      percentage.should include(1)
      percentage.should include([])
      percentage.should include({})
      percentage.should include(Object.new)
    end
  end

  describe "#<=>" do
    context "percentage is less than given percentage" do
      it "returns -1" do
        (Percentage(0) <=> Percentage(100)).should eq(-1)
      end
    end

    context "percentage is equal to given percentage" do
      it "returns 0" do
        (Percentage(100) <=> Percentage(100)).should eq(0)
      end
    end

    context "percentage is greater than given percentage" do
      it "returns 1" do
        (Percentage(100) <=> Percentage(0)).should eq(1)
      end
    end
  end

  describe "#to_i" do
    it "returns the integer value of the percentage" do
      Percentage(50).to_i.should eq(50)
    end
  end

  describe "#to_f" do
    it "returns the value of the percentage as a float" do
      Percentage(50).to_f.should eq(50.0)
    end
  end

  describe "#to_s" do
    it "returns a human readable version of the percentage" do
      Percentage(25).to_s.should eq("25%")
    end
  end

  describe "#inspect" do
    it "returns a human readable version of the percentage" do
      Percentage(25).inspect.should eq("25%")
    end
  end

  describe "#min?" do
    context "the percentage's value is 0" do
      it "returns true" do
        Percentage(0).should be_min
      end
    end

    context "the percentage's value is not 0" do
      it "returns false" do
        Percentage(1).should_not be_min
        Percentage(50).should_not be_min
        Percentage(100).should_not be_min
      end
    end
  end

  describe "#max?" do
    context "the percentage's value is 100" do
      it "returns true" do
        Percentage(100).should be_max
      end
    end

    context "the percentage's value is not 100" do
      it "returns false" do
        Percentage(0).should_not be_max
        Percentage(1).should_not be_max
        Percentage(50).should_not be_max
      end
    end
  end
end

describe "Percentage conversion method" do
  it "wraps the given numeric in a Percentage" do
    Percentage(50).should eq(Switches::Percentage.new(50))
  end

  context "value is already a Percentage" do
    it "returns the given Percentage" do
      percentage = Percentage(50)
      Percentage(percentage).should eq(percentage)
    end
  end
end
