resource("aws_security_group", "demo-sg-parent",
  name: var.name,
  description: "Demo Security Group Parent",
  tags: {
    Name: var.name,
  }
)

module!("sg_child_test",
  source: "../sg_child",
  # source: "git@github.com:boltops-tools/sg_child.git",

  name: "demo-sg-child",
)
