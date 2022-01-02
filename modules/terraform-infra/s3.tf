resource "aws_s3_bucket" "tfstate_s3" {
  bucket = "${var.app_id}-tfstate-s3-${var.environment_name}"

  # Set Access Control List (ACL) for Terraform State S3 bucket
  # to List, Read, Write for Bucket owner only
  acl = "private"

  # Enable versioning in case we need to recover previous versions of the Terraform state
  versioning {
    enabled = true
  }

  # Encrypt the Terraform state using the default `aws/s3` AWS KMS master key
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
  # In production, to prevent accidental destruction these values would be
  # force_destroy = false
  # lifecycle {
  #   prevent_destroy = true
  # }
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "${var.app_id} ${var.environment_name} Terraform tfstate S3"
  }
}

# Block all public access to Terraform state S3 bucket
resource "aws_s3_bucket_public_access_block" "tfstate_s3" {
  bucket = aws_s3_bucket.tfstate_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

## Only allow Transport Layer Security (TLS) access to the Terraform state S3 bucket
resource "aws_s3_bucket_policy" "tfstate_s3" {
  bucket = aws_s3_bucket.tfstate_s3.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Sid       = "AllowTLSRequestsOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = ["s3:*"]
        Resource  = [aws_s3_bucket.tfstate_s3.arn, "${aws_s3_bucket.tfstate_s3.arn}/*"]
        Condition = {
          Bool = { "aws:SecureTransport" : false }
        }
      }
    ]
  })
}