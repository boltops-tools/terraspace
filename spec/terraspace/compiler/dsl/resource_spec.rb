describe Terraspace::Compiler::Dsl::Mod do
  let(:builder) { described_class.new(mod, path) }
  let(:mod)     { Terraspace::Mod.new("vpc") }

  context "vpc" do
    let(:path) { fixture("projects/ruby/aws/app/modules/vpc/main.rb") }
    it "evaluate" do
      result = builder.build
      json =<<~EOL.strip
        {
          "resource": {
            "aws_vpc": {
              "vpc": {
                "cidr_block": "${var.cidr_block}",
                "tags": {
                  "Name": "${var.name}"
                }
              }
            }
          }
        }
      EOL
      expect(result).to eq(json)
    end
  end

  context "security_group" do
    let(:path) { fixture("projects/ruby/aws/app/modules/security_group/main.rb") }
    it "adds null for required props" do
      result = builder.build
      json =<<~EOL.strip
        {
          "resource": {
            "aws_security_group": {
              "demo-sg": {
                "name": "${var.name}",
                "description": "Demo Security Group",
                "ingress": [
                  {
                    "description": "TLS from VPC",
                    "from_port": 443,
                    "to_port": 443,
                    "protocol": "tcp",
                    "cidr_blocks": [
                      "0.0.0.0/0"
                    ],
                    "ipv6_cidr_blocks": null,
                    "prefix_list_ids": null,
                    "security_groups": null,
                    "self": null
                  }
                ],
                "tags": {
                  "Name": "${var.name}"
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
