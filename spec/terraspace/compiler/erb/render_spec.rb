describe Terraspace::Compiler::Erb::Render do
  let(:render) { described_class.new(mod, src_path) }
  let(:mod)    do
    mod = Terraspace::Mod.new("a1")
    mod.resolved = false
    mod
  end

  # Only testing mod unresolved as a sanity check and its worth the ROI.
  # The resolved would the Fetcher. We have unit tests to cover those other changes.
  context "a1" do
    let(:src_path) { fixture("dependencies/app/stacks/a1/tfvars/dev.tfvars") }
    it "build" do
      allow(Terraspace::Terraform::RemoteState::Marker::Output).to receive(:stack_names).and_return("b1")
      result = render.build
      expect(result).to eq "length = (unresolved)"
    end
  end
end
