## Example

    $ terraspace plan demo
    => terraform plan
    Refreshing Terraform state in-memory prior to plan...
    The refreshed state will be used to calculate this plan, but will not be
    persisted to local or remote state storage.

    random_pet.this: Refreshing state... [id=fond-sheep]
    module.bucket.aws_s3_bucket.this: Refreshing state... [id=bucket-fond-sheep]

    ------------------------------------------------------------------------

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    -/+ destroy and then create replacement
    ...
    Plan: 2 to add, 0 to change, 2 to destroy.

    Changes to Outputs:
      ~ bucket_name = "bucket-fond-sheep" -> (known after apply)

    ------------------------------------------------------------------------

    Note: You didn't specify an "-out" parameter to save this plan, so Terraform
    can't guarantee that exactly these actions will be performed if
    "terraform apply" is subsequently run.

    $

Using plan output path. You can specify an output path for the plan. Example:

    $ terraspace plan demo --out "my.plan"

You can then use this later in terraspace up:

    $ terraspace up demo --plan "my.plan"
