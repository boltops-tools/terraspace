describe Terraspace::Dependency::Helper::DependsOn do
  let(:depends_on) do
    described_class.new(mod, identifier, options)
  end
  let (:mod) { Terraspace::Mod.new("a1") }
  # follow args dont matter for spec
  let (:identifier) { "b1" }
  let (:options) { {} }

  context "unresolved" do
    before(:each) { mod.resolved = false }
    it "result calls Marker::Output" do
      allow(Terraspace::Terraform::RemoteState::Marker::Output).to receive(:new).and_return(double(:marker_output).as_null_object)
      result = depends_on.result
      expect(result).to be_a(RSpec::Mocks::Double)
      expect(result.instance_variable_get(:@name)).to eq :marker_output
    end
  end

  context "resolved" do
    before(:each) { mod.resolved = true }
    it "return an raw String" do
      result = depends_on.result
      expect(result).to eq "# a1 depends on b1"
    end
  end
end
