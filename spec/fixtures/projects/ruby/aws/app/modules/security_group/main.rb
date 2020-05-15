resource("aws_security_group", "demo-sg",
  name: var.name,
  description: "Demo Security Group",

  ingress: [
    description: "TLS from VPC",
    from_port:   443,
    to_port:     443,
    protocol:    "tcp",
    cidr_blocks: ["0.0.0.0/0"], # aws_vpc.main.cidr_block
  ],

  tags: {
    Name: var.name,
  }
)
