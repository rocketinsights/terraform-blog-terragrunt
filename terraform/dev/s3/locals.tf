# These Terraform variables are common across all environments (dev, qa, prod)
# They can be consolidated in common.tfvars in Terragrunt
locals {
  project_name = "terraform-blog-terragrunt"
  app_id       = "terraform-plain"
}
