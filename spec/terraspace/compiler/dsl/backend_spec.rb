describe Terraspace::Compiler::Dsl::Mod do
  let(:builder)        { described_class.new(mod, path) }
  let(:mod)            { "vpc" }

  let(:null) { double(:null).as_null_object }

  context "vpc" do
    let(:path) { fixture("orphans/config/backend.rb") }
    it "evaluate" do
      allow(builder).to receive(:default_state_prefix).and_return(null)
      result = builder.build
      json =<<~EOL.strip
{
  "terraform": {
    "backend": {
      "s3": {
        "bucket": "demo-bucket",
        "key": "#[Double :null]/terraform.tfstate",
        "region": "us-west-2",
        "encrypt": true,
        "dynamodb_table": "lock-table"
      }
    }
  }
}
      EOL
      expect(result).to eq(json)
    end
  end
end
