resource("aws_security_group", "demo-sg-child",
  name: var.name,
  description: "Demo Security Group Child",
  tags: {
    Name: var.name,
  }
)
