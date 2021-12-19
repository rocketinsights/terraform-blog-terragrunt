module "terraform_infra" {
  # Uncomment to use local module source
  # source = "..\/..\/..\/..\/modules/terraform-infra"
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/terraform-infra?ref=main"

  environment_name = var.environment_name
  app_id           = local.app_id
}
