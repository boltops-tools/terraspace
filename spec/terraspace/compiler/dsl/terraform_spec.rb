describe Terraspace::Compiler::Dsl::Mod do
  let(:builder) { described_class.new(mod, path) }
  let(:mod)     { Terraspace::Mod.new("terraform") }

  context "forum" do
    let(:path) { fixture("orphans/terraform/terraform.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "terraform": {
    "required_providers": {
      "aws": ">= 2.7.0"
    }
  }
}
      EOL
      expect(result).to eq(json)
    end
  end
end
