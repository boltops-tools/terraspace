describe Terraspace::Compiler::Dsl::Mod do
  let(:builder)        { described_class.new(mod, path) }
  let(:mod)            { "vpc" }

  context "single provider" do
    let(:path) { fixture("orphans/config/provider.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "provider": [
    {
      "aws": {
        "region": "us-west-2"
      }
    }
  ]
}
EOL
      expect(result).to eq(json)
    end
  end

  context "multiple different provider" do
    let(:path) { fixture("orphans/config/providers_different.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "provider": [
    {
      "aws": {
        "region": "us-west-2"
      }
    },
    {
      "google": {
        "region": "us-central1"
      }
    }
  ]
}
EOL
      expect(result).to eq(json)
    end
  end

  context "multiple same provider with aliases" do
    let(:path) { fixture("orphans/config/providers_same.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "provider": [
    {
      "aws": {
        "region": "eu-west-1"
      }
    },
    {
      "aws": {
        "alias": "eu-central-1",
        "region": "eu-central-1"
      }
    }
  ]
}
EOL
      expect(result).to eq(json)
    end
  end
end
