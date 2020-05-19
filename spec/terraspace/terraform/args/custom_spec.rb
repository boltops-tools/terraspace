describe Terraspace::Terraform::Args::Custom do
  let(:custom) do
    custom = described_class.new(mod, name)
    custom.instance_variable_set(:@file, file) # override @file for spec
    custom
  end
  let(:mod) { double(:mod).as_null_object }

  context "single" do
    let(:file) { fixture("terraform/args/single.rb") }
    let(:name) { "apply" }
    it "build creates the @commands structure" do
      commands = custom.build
      expect(commands.keys).to include("apply")
    end

    it "args" do
      custom.build
      expect(custom.args).to eq(["-lock-timeout=20m"])
    end

    it "var_files" do
      custom.build
      allow(custom).to receive(:var_file_exist?).and_return(true)
      expect(custom.var_files).to eq(["-var-file=a.tfvars", "-var-file=b.tfvars"])
    end
  end

  context "multiple" do
    let(:file) { fixture("terraform/args/multiple.rb") }
    let(:name) { "apply" }
    it "build creates the @commands structure" do
      commands = custom.build
      expect(commands.keys).to include("apply")
    end

    it "args" do
      custom.build
      expect(custom.args).to eq(["-lock-timeout=20m"])
    end

    it "var_files" do
      custom.build
      allow(custom).to receive(:var_file_exist?).and_return(true)
      expect(custom.var_files).to eq([])
    end
  end
end
