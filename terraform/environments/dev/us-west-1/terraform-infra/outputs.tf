output "tfstate_s3_id" {
  value = module.terraform_infra.tfstate_s3_id
}

output "tfstate_s3_arn" {
  value = module.terraform_infra.tfstate_s3_arn
}

output "tfstate_dynamodb_id" {
  value = module.terraform_infra.tfstate_dynamodb_id
}

output "tfstate_dynamodb_arn" {
  value = module.terraform_infra.tfstate_dynamodb_arn
}
