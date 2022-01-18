# This example VPC mimics the default AWS VPC setup
module "terraform_plain_iam" {
  # Uncomment to use local module source
  # source = "../../../modules/env-iam"
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/env-iam?ref=main"

  project_name      = local.project_name
  environment_name  = var.environment_name
  app_id            = local.app_id
  bucket_name       = data.terraform_remote_state.lookup_s3_module.outputs.terraform_plain_s3.id
}