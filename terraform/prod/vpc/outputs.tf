# In Terraform, note the manual definition of outputs to expose data from module as a map
# Int Terragrunt, the outputs of the modules are automatically outputted
output "terraform_plain_vpc" {
  value = module.terraform_plain_vpc
}
