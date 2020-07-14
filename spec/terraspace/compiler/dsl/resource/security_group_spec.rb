describe Terraspace::Compiler::Dsl::Mod do
  let(:builder) { described_class.new(mod, path) }
  let(:mod)     { Terraspace::Mod.new("vpc") }

  context "security_group with hash ingress" do
    let(:path) { fixture("orphans/resource/security_group/hash_example.rb") }
    it "adds null for required props" do
      result = builder.build
      json =<<~EOL.strip
{
  "resource": {
    "aws_security_group": {
      "demo-sg": {
        "name": "${var.name}",
        "description": "Demo Security Group",
        "vpc_id": "${var.vpc_id}",
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
