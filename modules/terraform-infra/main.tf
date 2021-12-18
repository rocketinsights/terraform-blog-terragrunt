resource "aws_s3_bucket" "tfstate_s3" {
  bucket        = "${var.app_id}-tfstate-s3-${var.environment_name}"
  acl           = "private"

  versioning {
    enabled = true
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

resource "aws_dynamodb_table" "tfstate_dynamodb" {
  name           = "${var.app_id}-tfstate-dynamodb-${var.environment_name}"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.app_id} ${var.environment_name} Terraform tfstate dynamodb"
  }
}