module!("vpc2",
  source: "../../modules/vpc",

  name:   "test-vpc2",
  cidr_block: var.cidr_block,
)
