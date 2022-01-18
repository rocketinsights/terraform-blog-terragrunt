data "aws_iam_policy" "ssm_access" {
  name = "AmazonSSMFullAccess"
}

# This lookup of the S3 bucket on AWS ensures that it exists
# and exits out early if it does not
data "aws_s3_bucket" "app_s3_bucket" {
  bucket = var.bucket_name
}