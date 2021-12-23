# This example VPC mimics the default AWS VPC setup
module "terraform_plain_s3" {
  # Uncomment to use local module source
  # source = "../../../../modules/simple-s3"
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/simple-s3?ref=main"

  environment_name = var.environment_name
  app_id           = local.app_id
  bucket_name      = var.bucket_name
}