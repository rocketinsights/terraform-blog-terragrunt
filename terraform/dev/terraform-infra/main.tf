module "terraform_infra" {
  # In Terraform, uncomment to use local module source
  # source = "../../../modules/terraform-infra"
  # In Terragrunt, no need to uncomment anything for local development
  # terragrunt apply --terragrunt-source=../../..//modules/terraform-infra
  #
  # Note that in Terragrunt the module git URL is centralized in the _envcommon/common.hcl
  # instead of copy and pasted in multiple main.tf
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/terraform-infra?ref=main"

  # In Terraform, environment_name and app_id variable assignment are duplicated in multiple main.tf
  # In Terragrunt, these common modules variables are assigned once in the `inputs` section
  # of the root terragrunt.hcl
  environment_name = var.environment_name
  app_id           = local.app_id
}
