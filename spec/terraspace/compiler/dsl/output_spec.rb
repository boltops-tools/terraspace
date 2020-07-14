describe Terraspace::Compiler::Dsl::Mod do
  let(:builder) { described_class.new(mod, path) }
  let(:mod)     { Terraspace::Mod.new("vpc") }

  context "vpc" do
    let(:path) { fixture("projects/ruby/aws/app/modules/vpc/outputs.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
        {
          "output": {
            "vpc_arn": {
              "description": "VPC arn",
              "value": "${aws_vpc.vpc.arn}"
            }
          }
        }
      EOL
      expect(result).to eq(json)
    end
  end
end
