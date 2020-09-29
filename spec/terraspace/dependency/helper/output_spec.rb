describe Terraspace::Dependency::Helper::Output do
  let(:output) do
    described_class.new(mod, identifier, options)
  end
  let (:mod) { Terraspace::Mod.new("foo") }
  # doesnt matter for spec
  let (:identifier) { nil }
  let (:options) { nil }

  context "unresolved" do
    before(:each) { mod.resolved = false }
    it "result calls Marker::Output" do
      allow(Terraspace::Terraform::RemoteState::Marker::Output).to receive(:new).and_return(double(:marker_output).as_null_object)
      result = output.result
      expect(result).to be_a(RSpec::Mocks::Double)
      expect(result.instance_variable_get(:@name)).to eq :marker_output
    end
  end

  context "resolved" do
    before(:each) { mod.resolved = true }
    it "result calls Fetcher" do
      allow(Terraspace::Terraform::RemoteState::Fetcher).to receive(:new).and_return(double(:fetcher_output).as_null_object)
      result = output.result
      expect(result).to be_a(RSpec::Mocks::Double)
      expect(result.instance_variable_get(:@name)).to eq :fetcher_output
    end
  end
end
