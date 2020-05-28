# Terraspace

[![Gem Version](https://badge.fury.io/rb/terraspace.png)](http://badge.fury.io/rb/terraspace)

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

The Terraform Framework

## Usage

Create infrastructure:

    $ terraspace up demo -y
    Materializing .terraspace-cache/dev/stacks/demo
    Current directory: .terraspace-cache/dev/stacks/demo
    => terraform init -get > /dev/null
    Built in .terraspace-cache/dev/stacks/demo
    => terraform apply -auto-approve
    random_pet.bucket: Creating...
    random_pet.bucket: Creation complete after 0s [id=amusing-mouse]
    module.bucket.aws_s3_bucket.this: Creating...
    module.bucket.aws_s3_bucket.this: Creation complete after 1s [id=bucket-amusing-mouse]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    bucket_name = bucket-amusing-mouse
    $

Destroy infrastructure:

    $ terraspace down demo -y
    Materializing .terraspace-cache/dev/stacks/demo
    Current directory: .terraspace-cache/dev/stacks/demo
    => terraform init -get > /dev/null
    Built in .terraspace-cache/dev/stacks/demo
    => terraform destroy -auto-approve
    random_pet.bucket: Refreshing state... [id=amusing-mouse]
    module.bucket.aws_s3_bucket.this: Refreshing state... [id=bucket-amusing-mouse]
    module.bucket.aws_s3_bucket.this: Destroying... [id=bucket-amusing-mouse]
    module.bucket.aws_s3_bucket.this: Destruction complete after 1s
    random_pet.bucket: Destroying... [id=amusing-mouse]
    random_pet.bucket: Destruction complete after 0s

    Destroy complete! Resources: 2 destroyed.
    $

## Features

* [Config Structure](https://terraspace.cloud/docs/config/): A common config structure that gets materializes with the deployed module. Configs can be dynamically controlled keep your code DRY. You can override the settings if needed, like for using existing backends. See: [Existing Backends](https://terraspace.cloud/docs/state/existing/).
* [Generators](https://terraspace.cloud/docs/generators/): Built-in generators to quickly create the starter module. Focus on code instead of boilerplate structure.
* [Tfvars](https://terraspace.cloud/docs/tfvars/): Use the same code with different tfvars to create multiple environments. Terraspace conventionally loads tfvars from the `tfvars` folder. Tfvars also support [Layering](https://terraspace.cloud/docs/tfvars/layering/).
* [Testing](https://terraspace.cloud/docs/testing/): A testing framework that allows you to create test harnesses, deploy real-resources, and have higher confidence that your code works.
* [Configurable CLI](https://terraspace.cloud/docs/cli/): Configurable [CLI Hooks](https://terraspace.cloud/docs/cli/hooks/) and [CLI Args](https://terraspace.cloud/docs/cli/args/) allow you to adjust the underlying terraform command.

For more docs: [Docs](https://github.com/boltops-tools/terraspace-docs)

## Installation

Install with:

    gem install terraspace
