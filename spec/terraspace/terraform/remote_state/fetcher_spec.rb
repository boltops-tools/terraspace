describe Terraspace::Terraform::RemoteState::Fetcher do
  let(:fetcher) do
    fetcher = described_class.new(parent, identifier)
    allow(fetcher).to receive(:validate!)
    allow(fetcher).to receive(:pull)
    allow(fetcher).to receive(:state_path).and_return(state_path)
    allow(fetcher).to receive(:pull_success?).and_return(pull_success)
    fetcher
  end
  let(:parent) do
    double("c1").as_null_object
  end

  context "pull success" do
    let(:state_path)   { "spec/fixtures/fetcher/c1.json" }
    let(:pull_success) { true }

    context "c1.length" do
      let(:identifier) { "c1.length" }
      it "fetched found attribute" do
        expect(fetcher.output.raw).to eq 1 # matches spec/fixtures/fetcher/c1.json outputs.length.value
      end
    end

    context "c1.does-not-exist" do
      let(:identifier) { "c1.does-not-exist" }
      it "fetched missing output" do
        output_proxy = fetcher.output
        expect(output_proxy.raw).to be nil
        # (Output length9 was not found for the b1 tfvars file. Either c1 stack has not been deployed yet or it does not have this output: length9)
        error = output_proxy.options[:error]
        expect(error).to include "not found"
      end
    end
  end

  context "pull fail" do
    let(:state_path)   { nil }
    let(:pull_success) { false }

    context "c1.length" do
      let(:identifier) { "c1.length" }
      it "fetched" do
        output_proxy = fetcher.output
        expect(output_proxy.raw).to be nil
        # (Output length could not be looked up for the b1 tfvars file. c1 stack needs to be deployed)
        error = output_proxy.options[:error]
        expect(error).to include "stack needs to be deployed"
      end
    end
  end
end
