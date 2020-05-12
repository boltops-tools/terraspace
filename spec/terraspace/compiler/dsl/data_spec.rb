describe Terraspace::Compiler::Dsl::Mod do
  let(:builder)        { described_class.new(mod, path) }
  let(:mod)            { "forum" }

  context "form" do
    let(:path) { fixture("orphans/data/aws_ami.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
{
  "data": {
    "aws_ami": {
      "example": {
        "most_recent": true,
        "owners": [
          "self"
        ],
        "tags": {
          "Name": "app-server",
          "Tested": "true"
        }
      }
    }
  }
}
      EOL
      expect(result).to eq(json)
    end
  end
end
