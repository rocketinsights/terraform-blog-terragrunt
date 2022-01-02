# Common configuration variables applicable to all environments (dev, qa, prod)
# Replaces duplicate Terraform locals.tf in all Terraform infrastructure code
locals {
  project_name = "terraform-blog-terragrunt"
  app_id       = "terraform-terragrunt"
  base_module_source_url = "github.com/rocketinsights/terraform-blog-terragrunt//modules"
}