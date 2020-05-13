variable "cidr_block" {
  default     = "10.90.0.0/16"
  description = "cidr block"
  type        = string
}

variable "name" {
  default     = "demo-vpc-hcl"
  description = "demo vpc"
  type        = string
}
