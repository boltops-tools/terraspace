describe Terraspace::Compiler::Dsl::Meta::Local do
  let(:local) { described_class.new }

  context "local" do
    it "a" do
      result = local.a
      expect(result).to eq "${local.a}"
    end
  end
end
