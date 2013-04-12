require "spec_helper"

describe Switches::Cohort do
  let(:instance) { stub(set: true, notify: true) }

  let(:cohort) { Switches::Cohort.new("power_users", instance) }

  describe ".collection" do
    it "returns a new collection for creating and holding cohort instances" do
      instance = stub(get: { "members" => [] })
      collection = Switches::Cohort.collection(instance)
      collection.should be_an_instance_of(Switches::Collection)
      collection[:members].should be_an_instance_of(Switches::Cohort)
    end
  end

  describe "#reload" do
    it "updates attributes from the data store" do
      instance = stub(get: { "members" => ["user_1", "user_2"] })
      cohort = Switches::Cohort.new("cohort", instance)
      cohort.members.should be_empty
      cohort.reload
      cohort.members.should include("user_1", "user_2")
    end
  end

  describe "#include?" do
    context "identifier is not a member of the cohort" do
      it "returns false" do
        cohort.should_not include(123)
      end
    end

    context "identifier is a member of the cohort" do
      it "returns true" do
        cohort.add(123)
        cohort.should include(123)
      end
    end

    it "coerces input into a string" do
      cohort.add(123)
      cohort.should include("123")

      cohort.add("123")
      cohort.should include(123)
    end
  end

  describe "#add" do
    it "adds the identifier to the cohort's members" do
      expect {
        cohort.add("123")
      }.to change { cohort.members }.from([]).to(["123"])
    end

    it "coerces input into a string" do
      expect {
        cohort.add(123)
      }.to change { cohort.members }.from([]).to(["123"])
    end
  end

  describe "#remove" do
    it "removes the identifier from the cohort's members" do
      cohort.add(123)

      expect {
        cohort.remove(123)
      }.to change { cohort.members }.from(["123"]).to([])
    end

    context "the identifier is not a member of the cohort" do
      it "doesn't change the members" do
        cohort.add(123)

        expect {
          cohort.remove(456)
        }.to_not change { cohort.members }
      end
    end
  end

  describe "#inspect" do
    it "shows the cohort name and the number of members" do
      cohort.add(123).add(456).add(789)
      cohort.inspect.should eq("#<Cohort power_users; 3 members>")
    end
  end

  describe "#as_json" do
    it "returns the cohort's attributes" do
      cohort.add(123)
      cohort.as_json.should eq(
        name: "power_users",
        members: ["123"]
      )
    end
  end

  describe "#members" do
    it "returns an array of cohort members" do
      cohort.add(123).add(456).add(789)
      cohort.members.should include("123", "456", "789")
    end
  end

  describe "#type" do
    it "returns 'cohort'" do
      cohort.type.should eq("cohort")
    end
  end

  describe "#key" do
    it "returns the type and cohort name joined by a colon" do
      cohort.key.should eq("cohort:power_users")
    end
  end
end
