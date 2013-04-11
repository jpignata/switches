require "spec_helper"

describe Switches::Backend do
  describe ".factory" do
    context "a redis URL" do
      it "returns a redis backend" do
        Switches::Backend.factory("redis://localhost:6379/5", stub).
          should be_an_instance_of(Switches::Backends::Redis)
      end
    end

    context "any other input" do
      it "returns a memory backend" do
        Switches::Backend.factory("memory:///", stub).
          should be_an_instance_of(Switches::Backends::Memory)
        Switches::Backend.factory("hello", stub).
          should be_an_instance_of(Switches::Backends::Memory)
        Switches::Backend.factory("http://zombo.com", stub).
          should be_an_instance_of(Switches::Backends::Memory)
      end
    end
  end
end
