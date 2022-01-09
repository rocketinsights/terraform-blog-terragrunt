# This example VPC mimics the default AWS VPC setup
module "terraform_plain_app_main" {
  # Uncomment to use local module source
  source = "../../../modules/app-main"
  # source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/app-main?ref=main"

  environment_name  = var.environment_name
  app_id            = local.app_id
  server_count      = var.server_count
  server_type       = var.server_type
}