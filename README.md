<div align="center">
  <a href="https://terraspace.cloud"><img src="https://img.boltops.com/boltops/logos/terraspace-dark-v2.png" /></a>
</div>

# Terraspace

[![Gem Version](https://badge.fury.io/rb/terraspace.png)](http://badge.fury.io/rb/terraspace)

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

The Terraform Framework.

Official Docs Site: [terraspace.cloud](https://terraspace.cloud)

Introduction Video:

[![Watch the video](https://img.boltops.com/boltops/tools/terraspace/terraspace-youtube.png)](https://www.youtube.com/watch?v=O87t5q22YNc)

## Quick Start

Here are commands to get started:

    terraspace new project infra --plugin aws --examples
    cd infra
    terraspace up demo
    terraspace down demo

* The `new` command generates a starter project.
* The `up` command creates an s3 bucket.
* The `down` command cleans up and deletes the bucket.

The default plugin is aws. Other plugins also supported are: google and azurerm.

## Usage

Create infrastructure:

    $ terraspace up demo -y
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform init -get > /tmp/terraspace/out/terraform-init20200824-21379-bkfvnh.out
    Built in .terraspace-cache/us-west-2/dev/stacks/demo
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
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform init -get > /tmp/terraspace/out/terraform-init20200824-21379-bkfvnh.out
    Built in .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform destroy -auto-approve
    random_pet.bucket: Refreshing state... [id=amusing-mouse]
    module.bucket.aws_s3_bucket.this: Refreshing state... [id=bucket-amusing-mouse]
    module.bucket.aws_s3_bucket.this: Destroying... [id=bucket-amusing-mouse]
    module.bucket.aws_s3_bucket.this: Destruction complete after 1s
    random_pet.bucket: Destroying... [id=amusing-mouse]
    random_pet.bucket: Destruction complete after 0s

    Destroy complete! Resources: 2 destroyed.
    $

## Deploy Multiple Stacks

To deploy all the infrastructure stacks:

    terraspace all up

To choose multiple stacks to deploy

    terraspace all up instance vpc

When you use the all command, the dependency graph is calculated and the stacks are deployed in the right order. To learn more: [Deploy Multiple Stacks](https://terraspace.cloud/docs/dependencies/deploy-all/).

## Features

* [Config Structure](https://terraspace.cloud/docs/config/): A common config structure that gets materializes with the deployed module. Configs can be dynamically controlled to keep your code DRY. You can override the settings if needed, like for using existing backends. See: [Existing Backends](https://terraspace.cloud/docs/state/existing/).
* [Generators](https://terraspace.cloud/docs/generators/): Built-in generators to quickly create the starter module. Focus on code instead of boilerplate structure.
* [Tfvars](https://terraspace.cloud/docs/tfvars/) & [Layering](https://terraspace.cloud/docs/tfvars/layering/): Use the same code with different tfvars to create multiple environments. Terraspace conventionally loads tfvars from the `tfvars` folder. Rich layering support allows you to build different environments like dev and prod with the same code.  Examples are in [Full Layering](https://terraspace.cloud/docs/tfvars/full-layering/).
* [Deploy Multiple Stacks](https://terraspace.cloud/docs/dependencies/deploy-all/): The ability to deploy multiple stacks with a single command. Terraspace calculates the [dependency graph](https://terraspace.cloud/docs/dependencies/) and deploys stacks in the right order. You can also target specific stacks and deploy [subgraphs](https://terraspace.cloud/docs/dependencies/subgraphs/).
* [Configurable CLI](https://terraspace.cloud/docs/cli/): Configurable [CLI Hooks](https://terraspace.cloud/docs/cli/hooks/) and [CLI Args](https://terraspace.cloud/docs/cli/args/) allow you to adjust the underlying terraform command.
* [Testing](https://terraspace.cloud/docs/testing/): A testing framework that allows you to create test harnesses, deploy real-resources, and have higher confidence that your code works.
* [Terraform Cloud and Terraform Enterprise Support](https://terraspace.cloud/docs/cloud/): TFC and TFE are both supported. Terraspace adds additional conveniences to make working with Terraform Cloud Workspaces easier.

For more info: [terraspace.cloud](https://terraspace.cloud)
