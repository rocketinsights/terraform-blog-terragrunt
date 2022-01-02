resource "aws_dynamodb_table" "tfstate_dynamodb" {
  name           = "${var.app_id}-tfstate-dynamodb-${var.environment_name}"
  hash_key       = "LockID"
  # On-demand PAY_PER_REQUEST is cheaper for Terraform since there are infrequent requests
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