# Terraspace

[![Gem Version](https://badge.fury.io/rb/terraspace.png)](http://badge.fury.io/rb/terraspace)

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

The Terraform Framework

## Usage

Create infrastructure stacks:

    $ terraspace up core -y
    Created .terraspace-cache/stacks/core/provider.tf.json
    Created .terraspace-cache/stacks/core/backend.tf.json
    Created .terraspace-cache/stacks/core/variables.tf.json
    Created .terraspace-cache/stacks/core/main.tf.json
    Created .terraspace-cache/stacks/core/outputs.tf.json
    ...
    Within dir: .terraspace-cache/stacks/core
    => terraform apply -auto-approve
    module.sg_nested2.module.sg_child_test.aws_security_group.demo-sg-child: Refreshing state... [id=sg-0816d7ea938d031de]
    module.vpc2.aws_vpc.vpc: Refreshing state... [id=vpc-0006839843392f564]
    module.sg_nested2.aws_security_group.demo-sg-nested: Refreshing state... [id=sg-0f7bebaaaf7c1a194]

    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    $

Destroy infrastructure stacks:

    $ terraspace down core -y
    Created .terraspace-cache/stacks/core/provider.tf.json
    Created .terraspace-cache/stacks/core/backend.tf.json
    ...
    Within dir: .terraspace-cache/stacks/core
    => terraform destroy -auto-approve
    module.vpc2.aws_vpc.vpc: Refreshing state... [id=vpc-0006839843392f564]
    ...
    module.sg_nested2.module.sg_child_test.aws_security_group.demo-sg-child: Destruction complete after 0s

    Destroy complete! Resources: 3 destroyed.
    $

## Docs

For more docs: [Docs](https://github.com/boltops-tools/terraspace-docs)

## Installation

Install with:

    gem install terraspace
