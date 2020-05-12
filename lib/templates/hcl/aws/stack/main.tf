module "vpc" {
  source     = "../../modules/example"
  name       = "demo-vpc"
  cidr_block = var.cidr_block
}
