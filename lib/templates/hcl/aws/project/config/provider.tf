# Docs: https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  region = "<%= ENV['AWS_REGION'] || 'us-east-1' %>"
}
