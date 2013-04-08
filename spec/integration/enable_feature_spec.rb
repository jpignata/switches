require "spec_helper"

describe "A feature is turned on globally" do
  let(:switches) do
    Switches do |config|
      config.backend = "memory:///"
    end
  end

  example do
    switches.feature(:login).should_not be_on
    switches.feature(:login).on
    switches.feature(:login).should be_on
  end
end
