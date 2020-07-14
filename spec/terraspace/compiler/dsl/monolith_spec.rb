describe Terraspace::Compiler::Dsl::Mod do
  let(:builder) { described_class.new(mod, path) }
  let(:mod)     { Terraspace::Mod.new("mono") }

  context "vpc" do
    let(:path) { fixture("projects/ruby/aws/app/stacks/monolith/main.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "resource": {
    "aws_vpc": {
      "vpc": {
        "cidr_block": "10.20.0.0/16"
      }
    }
  }
}
EOL
      expect(result).to eq(json)
    end
  end
end
