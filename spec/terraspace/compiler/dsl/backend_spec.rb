describe Terraspace::Compiler::Dsl::Mod do
  let(:builder) { described_class.new(mod, path) }
  let(:mod)     do
    mod = double(:mod).as_null_object
    allow(mod).to receive(:build_dir).and_return("modules/vpc")
    mod
  end

  let(:null) { double(:null).as_null_object }

  context "vpc" do
    let(:path) { fixture("orphans/config/backend.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "terraform": {
    "backend": {
      "s3": {
        "bucket": "demo-bucket",
        "key": "us-west-2/dev/modules/vpc/terraform.tfstate",
        "region": "us-west-2",
        "encrypt": true,
        "dynamodb_table": "terraform_locks"
      }
    }
  }
}
      EOL
      expect(result).to eq(json)
    end
  end
end
