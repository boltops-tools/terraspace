## Examples

    terraspace import ec2 aws_instance.this i-088a0a47e2e852cc8
    terraspace import vpc module.vpc.aws_vpc.this vpc-000782e4951a734c7
    terraspace import vpc module.vpc.aws_vpc.this vpc-000782e4951a734c7

A general workflow is to use terraspace plan, inspect what resources, are missing and and import resources based on that. The `state list` command is also useful.

    terraspace plan vpc
    terraspace import vpc module.vpc.aws_vpc.this vpc-000782e4951a734c7
    terraspace plan vpc
    terraspace import vpc module.vpc.aws_internet_gateway.this[0] igw-0fa4bec3b4b46948a
    terraspace state list vpc

Example with output:

    $ terraspace import vpc module.vpc.aws_internet_gateway.this[0] igw-0fa4bec3b4b46948a
    Building .terraspace-cache/us-west-2/dev/stacks/vpc
    Current directory: .terraspace-cache/us-west-2/dev/stacks/vpc
    => terraform import module.vpc.aws_internet_gateway.this[0] igw-0fa4bec3b4b46948a
    module.vpc.aws_internet_gateway.this[0]: Importing from ID "igw-0fa4bec3b4b46948a"...
    module.vpc.aws_internet_gateway.this[0]: Import prepared!
      Prepared aws_internet_gateway for import
    module.vpc.aws_internet_gateway.this[0]: Refreshing state... [id=igw-0fa4bec3b4b46948a]

    Import successful!

    The resources that were imported are shown above. These resources are now in
    your Terraform state and will henceforth be managed by Terraform.
