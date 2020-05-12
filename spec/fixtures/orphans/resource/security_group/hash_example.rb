resource("aws_security_group", "demo-sg",
  name: var("name"),
  description: "Demo Security Group",
  vpc_id: var("vpc_id"),

  # Hash example, normally with JSON need an an Array of Hashes
  ingress: {
    description: "TLS from VPC",
    from_port:   443,
    to_port:     443,
    protocol:    "tcp",
    cidr_blocks: ["0.0.0.0/0"], # aws_vpc.main.cidr_block
  },

  tags: {
    Name: var("name"),
  }
)
