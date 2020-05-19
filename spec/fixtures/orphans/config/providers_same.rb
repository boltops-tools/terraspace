provider("aws",
  region: "eu-west-1"
)

provider("aws",
  alias:  "eu-central-1",
  region: "eu-central-1",
)

# Usage later:
# module "vpc_frankfurt" {
#   providers {
#     aws = "aws.eu-central-1"
#   }
#   ...
# }
