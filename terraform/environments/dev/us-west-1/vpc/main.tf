# This example VPC mimics the default AWS VPC setup
module "terraform_plain_vpc" {
  # Uncomment to use local module source
  # source = "../../../../../modules/simple-vpc"
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/simple-vpc?ref=main"

  environment_name = var.environment_name
  app_id           = local.app_id
  cidr             = var.aws_cidr
  public_subnets   = var.aws_subnets
  azs              = var.aws_azs
}
