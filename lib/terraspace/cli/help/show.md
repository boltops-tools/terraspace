## Example

    $ terraspace show demo
    => terraform show
    # random_pet.this:
    resource "random_pet" "this" {
        id        = "fond-sheep"
        length    = 2
        separator = "-"
    }

    # module.bucket.aws_s3_bucket.this:
    resource "aws_s3_bucket" "this" {
        acl                         = "private"
        arn                         = "arn:aws:s3:::bucket-fond-sheep"
        bucket                      = "bucket-fond-sheep"
        bucket_domain_name          = "bucket-fond-sheep.s3.amazonaws.com"
        bucket_regional_domain_name = "bucket-fond-sheep.s3.us-west-2.amazonaws.com"
        force_destroy               = false
        hosted_zone_id              = "Z3BJ6K6RIION7M"
        id                          = "bucket-fond-sheep"
        region                      = "us-west-2"
        request_payer               = "BucketOwner"
        tags                        = {}

        versioning {
            enabled    = false
            mfa_delete = false
        }
    }


    Outputs:

    bucket_name = "bucket-fond-sheep"
    $