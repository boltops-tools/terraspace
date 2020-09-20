## Example

Terraspace test just calls the configured test framework, by default, rspec.
Here's an example with output cleaned up to reduce noise:

    $ terraspace test
    => rspec

    main
    Building test harness...
    ...
    Test harness built: /tmp/terraspace/test-harnesses/demo-harness
    => terraspace up demo -y
    Building .terraspace-cache/us-west-2/test/stacks/demo
    Built in .terraspace-cache/us-west-2/test/stacks/demo
    Current directory: .terraspace-cache/us-west-2/test/stacks/demo
    => terraform init -get >> /tmp/terraspace/log/init/demo.log
    => terraform plan -out /tmp/terraspace/plans/demo-20200920160313.plan
    ...
    => terraform apply -auto-approve  /tmp/terraspace/plans/demo-20200920160313.plan
    ...
    => terraform destroy -auto-approve
    random_pet.this: Refreshing state... [id=hopelessly-outgoing-serval]
    module.bucket.aws_s3_bucket.this: Refreshing state... [id=bucket-hopelessly-outgoing-serval]
    module.bucket.aws_s3_bucket.this: Destroying... [id=bucket-hopelessly-outgoing-serval]
    module.bucket.aws_s3_bucket.this: Destruction complete after 0s
    random_pet.this: Destroying... [id=hopelessly-outgoing-serval]
    random_pet.this: Destruction complete after 0s

    Destroy complete! Resources: 2 destroyed.
    Time took: 5s

    Finished in 22.08 seconds (files took 0.48602 seconds to load)
    1 example, 0 failures
    $