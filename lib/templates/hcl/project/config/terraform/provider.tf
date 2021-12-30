# This is where you put your provider declaration. Here are some examples:
#
# provider "aws" {
#   region = "<%= ENV['AWS_REGION'] || 'us-east-1' %>"
# }
#
# Docs: https://www.terraform.io/docs/providers/aws/index.html
#
# provider "azurerm" {
#   features {} # required
# }
#
# Docs: https://www.terraform.io/docs/providers/aws/index.html
#
# provider "google" {
#   project = "REPLACE_ME"
#   region  = "us-central1"   # update to your region
#   zone    = "us-central1-a" # update to your zone
# }
#
# Docs: https://www.terraform.io/docs/providers/google/index.html
#
# Note: If you add a provider, you should also configure a terraspace_plugin_* gem
# in the Terraspace project Gemfile and run bundle.
#