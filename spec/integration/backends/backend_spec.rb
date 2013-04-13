require "spec_helper"

shared_examples_for "a backend" do
  let(:host_a) do
    Switches do |config|
      config.backend = backend_url
    end
  end

  let(:host_b) do
    Switches do |config|
      config.backend = backend_url
    end
  end

  before do
    host_a.clear
  end

  after do
    host_a.stop
    host_b.stop
  end

  context "host_a turns a feature on" do
    example do
      host_a.feature(:redesign).percentage.should eq(Percentage(0))
      host_b.feature(:redesign).percentage.should eq(Percentage(0))

      host_a.feature(:redesign).on
      host_a.feature(:redesign).percentage.should eq(Percentage(100))

      eventually do
        host_b.feature(:redesign).percentage.should eq(Percentage(100))
      end
    end
  end

  context "host_a turns a feature on to a percentage" do
    example do
      host_a.feature(:redesign).percentage.should eq(Percentage(0))
      host_b.feature(:redesign).percentage.should eq(Percentage(0))

      host_a.feature(:redesign).on(25)
      host_a.feature(:redesign).percentage.should eq(Percentage(25))

      eventually do
        host_b.feature(:redesign).percentage.should eq(Percentage(25))
      end
    end
  end

  context "host_a turns a feature off" do
    example do
      host_a.feature(:redesign).on

      eventually do
        host_a.feature(:redesign).percentage.should eq(Percentage(100))
        host_b.feature(:redesign).percentage.should eq(Percentage(100))
      end

      host_a.feature(:redesign).off
      host_a.feature(:redesign).percentage.should eq(Percentage(0))

      eventually do
        host_b.feature(:redesign).percentage.should eq(Percentage(0))
      end
    end
  end

  context "host_a creates a power_users cohort and adds it to the feature" do
    example do
      host_a.cohort(:power_users).add("james_kirk")
      host_a.feature(:redesign).add("power_users")
      host_a.feature(:redesign).should be_on("james_kirk")
      host_a.feature(:redesign).should_not be_on("jean_luc_picard")

      eventually do
        host_b.feature(:redesign).cohorts.should include("power_users")
        host_b.feature(:redesign).should be_on("james_kirk")
        host_b.feature(:redesign).should_not be_on("jean_luc_picard")
      end
    end
  end

  context "host_b checks some users against a feature that is off, it gets turned on by host_a, host_b checks more users" do
    example do
      host_b.feature(:redesign).should_not be_on("james_kirk")
      host_b.feature(:redesign).should_not be_on("jean_luc_picard")

      host_a.feature(:redesign).on

      eventually do
        host_b.feature(:redesign).should be_on("james_kirk")
        host_b.feature(:redesign).should be_on("jean_luc_picard")
      end
    end
  end

  context "host_b checks some users against a feature that on for 37% of all actors" do
    example do
      host_b.feature(:redesign).should_not be_on("james_kirk")
      host_b.feature(:redesign).should_not be_on("jean_luc_picard")

      host_a.feature(:redesign).on(37)

      eventually do
        host_b.feature(:redesign).should be_on("james_kirk")
        host_b.feature(:redesign).should_not be_on("jean_luc_picard")
      end
    end
  end
end
