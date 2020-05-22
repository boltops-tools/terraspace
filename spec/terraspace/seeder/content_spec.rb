describe Terraspace::Seeder::Content do
  let(:content) { described_class.new(parsed) }

  context "basic examples" do
    let(:parsed) do
      {
        "variable"=>{
          "project"=>{"default"=>"project-name"},
          "name"=>{"type"=>"string"},
        }
      }
    end

    it "required_vars" do
      result = content.required_vars
      expect(result).to eq({"name"=>{"type"=>"string"}})
    end

    it "optional_vars" do
      result = content.optional_vars
      expect(result).to eq({"project"=>{"default"=>"project-name"}})
    end
  end

  context "description examples" do
    let(:parsed) do
      {
        "variable"=>{
          "project"=>{"default"=>"project-name", "description"=>"project name. IE: my-project"},
          "name"=>{"type"=>"string"},
          "azs"=>{"type"=>"list(string)"},
        }
      }
    end

    it "build" do
      result = content.build
      expected =<<~EOL
        # Required variables:
        name    = "string"
        azs     = [...] # list(string)

        # Optional variables:
        # project = "my-project"
      EOL
      expect(result).to eq(expected)
    end
  end
end
