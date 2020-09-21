describe Terraspace::Terraform::RemoteState::Marker::Output do
  let(:output) do
    output = described_class.new(mod, identifier, options)
    allow(output).to receive(:warning) # supress warning messaging about missing child stack
    output
  end
  let (:mod)        { Terraspace::Mod.new("a1") }
  let (:options)    { {} }

  before(:each) do
    Terraspace::Dependency::Registry.class_variable_set("@@data", Set.new)
  end

  # markers are always only called during unresolved stage
  context "child stack found" do
    let(:identifier) { "b1.length" }
    it "registers dependency and always return a OutputProxy" do
      allow(output).to receive(:valid?).and_return(true) # child stack found
      result = output.build
      expect(result).to be_a(Terraspace::Terraform::RemoteState::OutputProxy)
      set = Terraspace::Dependency::Registry.data
      expect(set).not_to be_empty
    end
  end

  context "child stack not found" do
    let(:identifier) { "b1.length" }
    it "does not registers dependency and always return a OutputProxy" do
      allow(output).to receive(:valid?).and_return(false) # child stack not found
      result = output.build
      expect(result).to be_a(Terraspace::Terraform::RemoteState::OutputProxy)
      set = Terraspace::Dependency::Registry.data
      expect(set).to be_empty
    end
  end
end
