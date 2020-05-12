describe Terraspace::Compiler::Dsl::Mod do
  let(:builder)        { described_class.new(mod, path) }
  let(:mod)            { "vpc" }

  context "vpc" do
    let(:path) { fixture("projects/ruby/aws/app/modules/vpc/variables.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
        {
          "variable": {
            "cidr_block": {
              "type": "string",
              "default": "10.90.0.0/16",
              "description": "cidr block"
            },
            "name": {
              "type": "string",
              "description": "vpc name",
              "default": "demo-vpc"
            }
          }
        }
      EOL
      expect(result).to eq(json)
    end
  end
end
