require "spec_helper"

shared_examples_for "a backend" do
  let(:alice) do
    Switches do |config|
      config.backend = backend_url
    end
  end

  let(:bob) do
    Switches do |config|
      config.backend = backend_url
    end
  end

  context "alice turns a feature on" do
    example do
      alice.feature(:redesign).percentage.should eq(Percentage(0))
      bob.feature(:redesign).percentage.should eq(Percentage(0))

      alice.feature(:redesign).on

      eventually do
        alice.feature(:redesign).percentage.should eq(Percentage(100))
        bob.feature(:redesign).percentage.should eq(Percentage(100))
      end
    end
  end

  context "alice turns a feature on to a percentage" do
    example do
      alice.feature(:redesign).percentage.should eq(Percentage(0))
      bob.feature(:redesign).percentage.should eq(Percentage(0))

      alice.feature(:redesign).on(25)

      eventually do
        alice.feature(:redesign).percentage.should eq(Percentage(25))
        bob.feature(:redesign).percentage.should eq(Percentage(25))
      end
    end
  end

  context "alice turns a feature off" do
    example do
      alice.feature(:redesign).on

      eventually do
        alice.feature(:redesign).percentage.should eq(Percentage(100))
        bob.feature(:redesign).percentage.should eq(Percentage(100))
      end

      alice.feature(:redesign).off

      eventually do
        alice.feature(:redesign).percentage.should eq(Percentage(0))
        bob.feature(:redesign).percentage.should eq(Percentage(0))
      end
    end
  end

  context "alice creates a power_users cohort and adds it to the feature" do
    example do
      alice.cohort("power_users").add("james_kirk")
      alice.feature(:redesign).add("power_users")
      alice.feature(:redesign).should be_on("james_kirk")
      alice.feature(:redesign).should_not be_on("jean_luc_picard")

      eventually do
        bob.feature(:redesign).cohorts.should include("power_users")
        bob.feature(:redesign).should be_on("james_kirk")
        bob.feature(:redesign).should_not be_on("jean_luc_picard")
      end
    end
  end
end
