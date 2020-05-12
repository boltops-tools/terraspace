describe Terraspace::Compiler::Dsl::Mod do
  let(:builder)        { described_class.new(mod, path) }
  let(:mod)            { "vpc" }

  context "vpc" do
    let(:path) { fixture("orphans/config/provider.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "provider": {
    "aws": {
      "region": "us-west-2"
    }
  }
}
EOL
      expect(result).to eq(json)
    end
  end
end
