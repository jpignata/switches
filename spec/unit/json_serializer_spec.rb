require "spec_helper"

describe Switches::JSONSerializer do
  context "module functions" do
    describe ".serialize" do
      it "returns a JSON string from the given input" do
        Switches::JSONSerializer.serialize({"one" => 1}).should eq('{"one":1}')
      end
    end

    describe ".deserialize" do
      it "inflates the given JSON string" do
        Switches::JSONSerializer.deserialize('{"one":1}').should eq({"one" => 1})
      end

      it "raises a JSONSerializer::ParserError if the given object can't be parsed" do
        expect {
          Switches::JSONSerializer.deserialize({})
        }.to raise_exception(Switches::JSONSerializer::ParserError)
      end
    end
  end

  context "mixed in" do
    let(:object) do
      Object.new.extend(Switches::JSONSerializer)
    end

    describe "#to_json" do
      it "calls #as_json and returns it as a JSON string" do
        def object.as_json
          {"one" => 1}
        end

        object.to_json.should eq('{"one":1}')
      end

      context "#as_json isn't defined on the host object" do
        it "raises NotImplementedError" do
          expect {
            object.to_json
          }.to raise_exception(NotImplementedError)
        end
      end
    end
  end
end
