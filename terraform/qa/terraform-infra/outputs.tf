# In Terraform, note the manual duplication of outputs to expose data from modules
# Int Terragrunt, the outputs of the modules are automatically outputted
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
