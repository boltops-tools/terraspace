describe Terraspace::Plugin::Expander::Generic do
  let(:expander) { described_class.new(mod) }
  let(:props) do
    {
      bucket:         "my-bucket",
      key:            ":env/:build_dir/terraform.tfstate", # variable notation expanded by terraspace
      region:         "us-west-2",
      encrypt:        true,
      dynamodb_table: "terraform_locks"
    }
  end
  let(:mod) do
    mod = double(:mod).as_null_object
    allow(mod).to receive(:build_dir).and_return("stacks/core")
    mod
  end

  context "default path" do
    it "expand" do
      result = expander.expand(props)
      expect(result).to eq({
        bucket: "my-bucket",
        key: "dev/stacks/core/terraform.tfstate",
        region: "us-west-2",
        encrypt: true,
        dynamodb_table: "terraform_locks"
      })
    end
  end
end
