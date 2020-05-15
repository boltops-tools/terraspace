describe Terraspace::Compiler::Dsl::Meta::Var do
  let(:var) { described_class.new }

  context "var" do
    it "a" do
      result = var.a
      expect(result).to eq "${var.a}"
    end
  end
end
