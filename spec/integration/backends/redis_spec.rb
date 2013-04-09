require "spec_helper"

describe "redis backend" do
  let(:host_1) do
    Switches do |config|
      config.backend = "redis://localhost:6379/11"
    end
  end

  let(:host_2) do
    Switches do |config|
      config.backend = "redis://localhost:6379/11"
    end
  end

  describe "host_1 turns a feature on, host_2 sees the feature as on" do
    example do
      host_1.feature(:redesign).should be_off
      host_2.feature(:redesign).should be_off

      host_1.feature(:redesign).on
      sleep 0.1

      host_1.feature(:redesign).should be_on
      host_2.feature(:redesign).should be_on
    end
  end

  describe "host_1 turns a feature on to a percentage, host_2 sees the feature as on to a percentage" do
    example do
      host_1.feature(:redesign).should be_off
      host_2.feature(:redesign).should be_off

      host_1.feature(:redesign).on(25)
      sleep 0.1

      host_1.feature(:redesign).should be_on
      host_2.feature(:redesign).should be_on
      host_2.feature(:redesign).percentage.should eq(25)
    end
  end
end
