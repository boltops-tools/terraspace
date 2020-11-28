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

The default plugin is aws. Major cloud providers are supported: [aws](https://terraspace.cloud/docs/learn/aws/), [azurerm](https://terraspace.cloud/docs/learn/azure/), [google](https://terraspace.cloud/docs/learn/gcp/).

## Usage

Create infrastructure:

    $ terraspace up demo
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform init -get >> /tmp/terraspace/log/init/demo.log
    => terraform apply
    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    $

Destroy infrastructure:

    $ terraspace down demo
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform destroy
    Destroy complete! Resources: 2 destroyed.
    $

* Blog: [Introducing Terraspace: The Terraform Framework](https://blog.boltops.com/2020/08/22/introducing-terraspace-the-terraform-framework)
* Docs: [Terraspace Intro](https://terraspace.cloud/docs/intro/)

## Deploy Multiple Stacks

To deploy all the infrastructure stacks:

    $ terraspace all up
    Will run:
        terraspace up vpc      # batch 1
        terraspace up mysql    # batch 2
        terraspace up redis    # batch 2
        terraspace up instance # batch 3
    Are you sure? (y/N)

To choose multiple stacks to deploy

    $ terraspace all up mysql redis
    Will run:
        terraspace up vpc   # batch 1
        terraspace up mysql # batch 2
        terraspace up redis # batch 2
    Are you sure? (y/N)

When you use the all command, the dependency graph is calculated and the stacks are deployed in the right order.

* Blog: [Terraspace All: Deploy Multiple Stacks or Terraform Modules At Once](https://blog.boltops.com/2020/09/19/terraspace-all-deploy-multiple-stacks-at-once)
* Docs: [Deploy Multiple Stacks](https://terraspace.cloud/docs/intro/deploy-all/).

## Terrafile

Terraspace makes it easy to use Terraform modules sourced from your own git repositories, other git repositories, or the Terraform Registry. Use any module you want:

Terrafile:

```ruby
# GitHub repo
mod "s3", source: "boltops-tools/terraform-aws-s3", tag: "v0.1.0"
# Terraform registry
mod "sg", source: "terraform-aws-modules/security-group/aws", version: "3.10.0"
```

To install modules:

    terraspace bundle

* Blog: [Terraspace Terrafile: Using Git and Terraform Registry Modules](https://blog.boltops.com/2020/10/18/terraspace-terrafile-using-git-repos-and-terraform-registry-modules)
* Docs: [Terrafile](https://terraspace.cloud/docs/terrafile/)

## Features

* [DRY](https://terraspace.cloud/docs/intro/how-terraspace-works/): You can keep your code DRY. Terraspace builds your Terraform project with common `app` and `config/terraform` structure that gets built each deploy. You can override the settings if needed, like for using existing backends. See: [Existing Backends](https://terraspace.cloud/docs/state/existing/).
* [Generators](https://terraspace.cloud/docs/generators/): Built-in generators to quickly create the starter module. Focus on code instead of boilerplate structure.
* [Multiple Environments](https://terraspace.cloud/docs/patterns/multiple-envs/): [Tfvars](https://terraspace.cloud/docs/tfvars/) & [Layering](https://terraspace.cloud/docs/tfvars/layering/) allow you to the same code with different tfvars to create multiple environments. Terraspace conventionally loads tfvars from the `tfvars` folder. Rich layering support allows you to build different environments like dev and prod with the same code.  Examples are in [Full Layering](https://terraspace.cloud/docs/tfvars/full-layering/).
* [Deploy Multiple Stacks](https://terraspace.cloud/docs/intro/deploy-all/): The ability to deploy multiple stacks with a single command. Terraspace calculates the [dependency graph](https://terraspace.cloud/docs/dependencies/) and deploys stacks in the right order. You can also target specific stacks and deploy [subgraphs](https://terraspace.cloud/docs/dependencies/subgraphs/).
* [Secrets Support](https://terraspace.cloud/docs/helpers/aws/secrets/): Terraspace has built-in secrets support for [AWS Secrets Manager](https://terraspace.cloud/docs/helpers/aws/secrets/), [AWS SSM Parameter Store](https://terraspace.cloud/docs/helpers/aws/ssm/), [Azure Key Vault](https://terraspace.cloud/docs/helpers/azure/secrets/), [Google Secrets Manager](https://terraspace.cloud/docs/helpers/google/secrets/). Easily set variables from Cloud secrets providers.
* [Terrafile](https://terraspace.cloud/docs/terrafile/): Terraspace makes it easy to use Terraform modules sourced from your own git repositories, other git repositories, or the Terraform Registry. The git repos can be private or public. This is an incredibly powerful feature of Terraspace because it opens up a world of modules for you to use.  Use any module you want.
* [Configurable CLI](https://terraspace.cloud/docs/config/args/): Configurable [CLI Hooks](https://terraspace.cloud/docs/config/hooks/) and [CLI Args](https://terraspace.cloud/docs/config/args/) allow you to adjust the underlying terraform command.
* [Testing](https://terraspace.cloud/docs/testing/): A testing framework that allows you to create test harnesses, deploy real-resources, and have higher confidence that your code works.
* [Terraform Cloud and Terraform Enterprise Support](https://terraspace.cloud/docs/cloud/): TFC and TFE are both supported. Terraspace adds additional conveniences to make working with Terraform Cloud Workspaces easier.

## Comparison

Here are some useful comparisons to help you compare Terraspace vs other tools in the ecosystem:

* [Terraspace vs Custom Solution](https://terraspace.cloud/docs/vs/custom/)
* [Terraspace vs Terraform](https://terraspace.cloud/docs/vs/terraform/)
* [Terraform vs Terragrunt vs Terraspace](https://blog.boltops.com/2020/09/28/terraform-vs-terragrunt-vs-terraspace)

More info: [terraspace.cloud](https://terraspace.cloud)
