describe Terraspace::Compiler::State::S3 do
  let(:state) { described_class.new(mod, "s3", props) }
  let(:props) do
    {
      bucket:         "my-bucket",
      key:            ":env/:build_dir/terraform.tfstate", # variable notation expanded by terraspace
      region:         ENV["AWS_REGION"],
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
      props = state.expand
      expect(props).to eq({
        bucket: "my-bucket",
        key: "development/stacks/core/terraform.tfstate",
        region: "us-west-2",
        encrypt: true,
        dynamodb_table: "terraform_locks"
      })
    end
  end
end
