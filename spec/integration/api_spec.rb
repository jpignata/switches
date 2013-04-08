require "spec_helper"

describe "API" do
  let(:switches) do
    Switches do |config|
      config.backend = "memory:///"
    end
  end

  describe "A feature is turned on globally" do
    example do
      switches.feature(:redesign).should_not be_on
      switches.feature(:redesign).on
      switches.feature(:redesign).should be_on
    end
  end

  describe "A feature is turned on to a percentage" do
    example do
      switches.feature(:redesign).should_not be_on
      switches.feature(:redesign).on(25)
      switches.feature(:redesign).should be_on
      switches.feature(:redesign).percentage.should eq(25)
    end
  end

  describe "A feature is turned off" do
    example do
      switches.feature(:redesign).on
      switches.feature(:redesign).should be_on
      switches.feature(:redesign).off
      switches.feature(:redesign).should_not be_on
      switches.feature(:redesign).should be_off
    end
  end
end
