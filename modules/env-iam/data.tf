data "aws_iam_policy" "ssm_access" {
  name = "AmazonSSMFullAccess"
}

# I am not a fan of remote state lookup since it tightly couples the modules
data "aws_s3_bucket" "app_s3_bucket" {
  bucket = "${var.app_id}-${var.bucket_name}-${var.environment_name}"
}