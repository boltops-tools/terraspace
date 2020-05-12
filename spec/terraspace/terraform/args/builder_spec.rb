describe Terraspace::Terraform::Args::Builder do
  let(:builder) do
    builder = described_class.new(mod, name)
    builder.instance_variable_set(:@file, file) # override @file for spec
    builder
  end
  let(:mod) { double(:mod).as_null_object }

  context "single" do
    let(:file) { fixture("terraform/args/single.rb") }
    let(:name) { "apply" }
    it "build creates the @commands structure" do
      commands = builder.build
      expect(commands.keys).to include("apply")
    end

    it "args" do
      builder.build
      expect(builder.args).to eq(["-lock-timeout=20m"])
    end

    it "var_files" do
      builder.build
      allow(builder).to receive(:var_file_exist?).and_return(true)
      expect(builder.var_files).to eq(["-var-file=a.tfvars", "-var-file=b.tfvars"])
    end
  end

  context "multiple" do
    let(:file) { fixture("terraform/args/multiple.rb") }
    let(:name) { "apply" }
    it "build creates the @commands structure" do
      commands = builder.build
      expect(commands.keys).to include("apply")
    end

    it "args" do
      builder.build
      expect(builder.args).to eq(["-lock-timeout=20m"])
    end

    it "var_files" do
      builder.build
      allow(builder).to receive(:var_file_exist?).and_return(true)
      expect(builder.var_files).to eq([])
    end
  end
end
