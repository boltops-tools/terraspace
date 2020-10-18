describe Terraspace::Hooks::Builder do
  let(:builder) do
    builder = described_class.new(mod, dsl_file, name)
    builder
  end
  let(:mod) do
    mod = double(:mod).as_null_object
    allow(mod).to receive(:cache_dir).and_return("/tmp")
    mod
  end

  context "single" do
    let(:dsl_file) { fixture("terraform/hooks/single.rb") }
    let(:name) { "apply" }
    it "build creates the @hooks structure" do
      hooks = builder.build
      expect(hooks.keys).to include("before")
    end

    it "run_hooks" do
      builder.build
      builder.run_hooks
    end
  end

  context "multiple" do
    let(:dsl_file) { fixture("terraform/hooks/multiple.rb") }
    let(:name) { "apply" }
    it "build creates the @hooks structure" do
      hooks = builder.build
      expect(hooks.keys).to include("before")
    end
  end
end
