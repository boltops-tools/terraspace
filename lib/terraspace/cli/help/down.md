## Example

    $ terraspace down demo
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Built in .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform destroy
    # ...
    Plan: 0 to add, 0 to change, 2 to destroy.

    Changes to Outputs:
      - bucket_name = "bucket-trusty-marmoset" -> null

    Do you really want to destroy all resources?
      Terraform will destroy all your managed infrastructure, as shown above.
      There is no undo. Only 'yes' will be accepted to confirm.
      Enter a value: yes

    module.bucket.aws_s3_bucket.this: Destroying... [id=bucket-trusty-marmoset]
    module.bucket.aws_s3_bucket.this: Destruction complete after 0s
    random_pet.this: Destroying... [id=trusty-marmoset]
    random_pet.this: Destruction complete after 0s

    Destroy complete! Resources: 2 destroyed.
    Time took: 21s
    $