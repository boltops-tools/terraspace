## Example

    $ terraspace up demo
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Built in .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform apply
    ...
    Plan: 2 to add, 0 to change, 0 to destroy.

    Changes to Outputs:
      + bucket_name = (known after apply)

    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.
      Enter a value: yes

    random_pet.this: Creating...
    random_pet.this: Creation complete after 0s [id=trusty-marmoset]
    module.bucket.aws_s3_bucket.this: Creating...
    module.bucket.aws_s3_bucket.this: Creation complete after 2s [id=bucket-trusty-marmoset]

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    bucket_name = bucket-trusty-marmoset
    Time took: 39s
    $