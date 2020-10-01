Unresolved = Terraspace::Terraform::RemoteState::Unresolved

describe Terraspace::Terraform::RemoteState::OutputProxy do
  let(:proxy) do
    described_class.new(mod, raw, options)
  end
  let (:mod) { Terraspace::Mod.new("foo") }
  let (:raw) { nil }
  let (:options) { {} }

  context "unresolved" do
    before(:each) { mod.resolved = false }
    it "always return Unresolved" do
      value = proxy.to_s
      expect(value).to be_a(Unresolved)
      expect(value.to_str).to eq "(unresolved)"
    end
  end

  # Resolved value should always return a String because ERB requires string.
  # Always use to_json.
  context "resolved with mock" do
    before(:each) { mod.resolved = true }
    let (:raw) { nil }
    let (:options) { {mock: "mock value"} }

    it "return to_json String with mock value" do
      value = proxy.to_s
      expect(value).to be_a(String)
      expect(value.to_str).to eq '"mock value"' # note double quotes from the to_json
    end
  end

  context "resolved with errors" do
    before(:each) { mod.resolved = true }
    let (:raw) { nil }
    let (:options) { {error: "error message"} }

    it "return to_json String with error message" do
      value = proxy.to_s
      expect(value).to be_a(String)
      expect(value.to_str).to eq '"error message"' # note double quotes from the to_json
    end
  end

  context "to_ruby resolved with mock" do
    before(:each) { mod.resolved = true }
    let (:raw) { nil }
    let (:options) { {mock: "mock value"} }

    it "return to_json String with mock value" do
      value = proxy.to_ruby
      expect(value).to be_a(String)
      expect(value.to_str).to eq "mock value"
    end
  end

  context "to_ruby resolved with errors" do
    before(:each) { mod.resolved = true }
    let (:raw) { nil }
    let (:options) { {error: "error message"} }

    it "return to_json String with error message" do
      value = proxy.to_ruby
      expect(value).to be_a(String)
      expect(value.to_str).to eq "error message"
    end
  end
end
