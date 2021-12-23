module "terraform_infra" {
  # Uncomment to use local module source
  # In Terragrunt, you can use local source without temporarily uncommenting via
  # terragrunt apply --terragrunt-source=../../../..//modules/terraform-infra
  # source = "../../../modules/terraform-infra"

  # Note that in Terraform the github URL is duplicated in each environment terraform-infra main.tf
  # In Terragrunt, the URL is in one file _envcommon/terraform-infra.hcl
  # Comment to use local module source
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/terraform-infra?ref=main"

  environment_name = var.environment_name
  app_id           = local.app_id
}
