# These Terraform variables are common across all environments (dev, qa, prod)
# In Terraform, these results in duplicate locals.tf across multiple resources
# In Terragrunt, these common variables are defined once in terragrunt/_envcommon/common.hcl
locals {
  project_name = "terraform-blog-terragrunt"
  app_id       = "terraform-plain"
}
