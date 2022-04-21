# This example VPC mimics the default AWS VPC setup
module "terraform_plain_vpc" {
  # In Terraform, uncomment to use local module source
  # source = "../../../modules/simple-vpc"
  # In Terragrunt, no need to uncomment anything for local development
  # terragrunt apply --terragrunt-source=../../..//modules/simple-vpc
  #
  # Note that in Terragrunt the module git URL is centralized in the terragrunt/_envcommon/common.hcl
  # instead of copy and pasted in multiple main.tf
  source = "github.com/rocketinsights/terraform-blog-terragrunt//modules/simple-vpc?ref=main"

  # In Terraform, environment_name and app_id variable assignment are duplicated in multiple main.tf
  # In Terragrunt, these common modules variables are assigned once in the `inputs` section
  # of the root terragrunt/terragrunt.hcl
  environment_name = var.environment_name
  app_id           = local.app_id
  cidr             = var.aws_cidr
  public_subnets   = var.aws_subnets
  azs              = var.aws_azs
}
