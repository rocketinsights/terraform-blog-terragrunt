# In Terraform, note the manual duplication of outputs to expose data from modules
# Int Terragrunt, the outputs of the modules are automatically outputted
output "id" {
  value = module.terraform_plain_iam.ec2_role_id
}

output "arn" {
  value = module.terraform_plain_iam.ec2_role_arn
}
