describe Terraspace::Compiler::Dsl::Mod do
  let(:builder)        { described_class.new(mod, path) }
  let(:mod)            { "forum" }

  context "forum" do
    let(:path) { fixture("orphans/locals/forum.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "locals": {
    "service_name": "forum",
    "owner": "Community Team"
  }
}
EOL
      expect(result).to eq(json)
    end
  end

  context "qux" do
    let(:path) { fixture("orphans/locals/qux.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "locals": {
    "foo": [
      {
        "bar": "baz"
      }
    ]
  },
  "output": {
    "qux": {
      "value": "${local.foo[0][\\\"bar\\\"]}"
    }
  }
}
EOL
      expect(result).to eq(json)
    end
  end
end
