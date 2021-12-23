# In Terraform, note the manual duplication of outputs to expose data from modules
# Int Terragrunt, the outputs of the modules are automatically outputted
output "id" {
  value = module.terraform_plain_s3.id
}

output "arn" {
  value = module.terraform_plain_s3.arn
}

output "region" {
  value = module.terraform_plain_s3.region
}