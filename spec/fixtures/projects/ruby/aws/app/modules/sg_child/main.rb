resource("aws_security_group", "demo-sg-child",
  name: var("name"),
  description: "Demo Security Group Child",
  # vpc_id: var("vpc_id"),
  tags: {
    Name: var("name"),
  }
)
