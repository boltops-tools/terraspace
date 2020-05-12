describe Terraspace::Compiler::Dsl::Mod do
  let(:builder)        { described_class.new(mod, path) }
  let(:mod)            { "core" }

  context "core" do
    let(:path) { fixture("orphans/module/core/main.rb") }
    it "evaluate" do
      result = builder.build
#       json =<<~EOL.strip
# EOL
#       expect(result).to eq(json)
    end
  end
end
