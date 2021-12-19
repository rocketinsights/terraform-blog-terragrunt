# Environment-level TF locals, replacing duplicate locals.tf keys
locals {
  # Automatically load variables commaon to all environments (dev, qa, prod)
  common_vars = read_terragrunt_config(find_in_parent_folders("_envcommon/common.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  app_id           = local.common_vars.locals.app_id
  # aws_region = "us-west-1"
  aws_region       = local.region_vars.locals.aws_region
  environment_name = "dev"
}

# Global TF variables input, replacing duplicate terraform.tfvars keys
inputs = {
  app_id           = local.app_id
  environment_name = local.environment_name
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings
# that are common across all environments (dev, qa, prod).
//include "envcommon" {
//  path   = "${dirname(find_in_parent_folders())}/../_envcommon/common.hcl"
//  expose = true
//}

# Global TF remote state, replacing duplicate providers.tf terraform backend
remote_state {
  backend = "s3"

  # No need to create the tfstate via terraform-infra module
  # If the S3 and DynamoDB resource does not exist, Terragrunt will create it
  # Notice you can use Terragrunt local variables in the backend config
  # In Terraform, variable usage is not allowed in the backend config
  config = {
    bucket = "${local.app_id}-tfstate-s3-${local.environment_name}"
    region = local.aws_region
    key = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "${local.app_id}-tfstate-dynamodb-${local.environment_name}"
    encrypt = true
  }
  generate = {
    path = "terragrunt-generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Generate an AWS provider block
generate "provider" {
  path = "terragrunt-generated-providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}
//terraform {
//  extra_arguments "common_vars" {
//    commands = [
//      "plan",
//      "apply",
//      "import",
//      "push",
//      "refresh"
//    ]
//
//    # Load Terraform variable that are common across all environments (dev, qa, prod)
//    arguments = [
//      "-var-file=${get_terragrunt_dir()}/../../common.tfvars"
//    ]
//  }
//}
