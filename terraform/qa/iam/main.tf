module "terraform_plain_iam" {
  # In Terraform, uncomment to use local module source
  # source = "../../../modules/env-iam"
  # In Terragrunt, no need to uncomment anything for local development
  # terragrunt apply --terragrunt-source=../../..//modules/env-iam
  #
  # Note that in Terragrunt the module git URL is centralized in the terragrunt/_envcommon/common.hcl
  # instead of copy and pasted in multiple main.tf
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/env-iam?ref=main"

  # In Terraform, environment_name and app_id variable assignment are duplicated in multiple main.tf
  # In Terragrunt, these common modules variables are assigned once in the `inputs` section
  # of the root terragrunt/terragrunt.hcl
  project_name      = local.project_name
  environment_name  = var.environment_name
  app_id            = local.app_id
  bucket_name       = data.terraform_remote_state.lookup_s3_module.outputs.terraform_plain_s3.id
}