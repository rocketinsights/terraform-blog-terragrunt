resource "aws_s3_bucket" "this" {
  bucket = "${var.app_id}-${var.bucket_name}-${var.environment_name}"
  acl    = "private"

  # In production, to prevent accidental destruction these values would be
  # force_destroy = false
  # lifecycle {
  #   prevent_destroy = true
  # }
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}
