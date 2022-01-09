# In Terraform, note the manual duplication of outputs to expose data from modules
# Int Terragrunt, the outputs of the modules are automatically outputted
output "ec2_role_id" {
  value = module.terraform_plain_iam.ec2_role_id
}

output "ec2_role_arn" {
  value = module.terraform_plain_iam.ec2_role_arn
}

output "ec2_instance_profile_arn" {
  value = module.terraform_plain_iam.ec2_instance_profile_arn
}
