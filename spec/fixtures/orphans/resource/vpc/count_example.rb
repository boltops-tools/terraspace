resource("aws_vpc", "vpc",
  count: 3,
  cidr_block: "10.50.0.0/16",
  tags: {
    Name: "#{Terraspace.env}-vpc-${count.index}"
  }
)
