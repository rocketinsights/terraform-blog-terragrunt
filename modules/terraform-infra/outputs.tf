output "tfstate_s3_id" {
  value = aws_s3_bucket.tfstate_s3.id
}

output "tfstate_s3_arn" {
  value = aws_s3_bucket.tfstate_s3.arn
}

output "tfstate_dynamodb_id" {
  value = aws_dynamodb_table.tfstate_dynamodb.id
}

output "tfstate_dynamodb_arn" {
  value = aws_dynamodb_table.tfstate_dynamodb.arn
}
