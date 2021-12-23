# Environment-level TF locals, replacing duplicate locals.tf keys
locals {
  # Automatically load variables common to all environments (dev, qa, prod)
  common_vars = read_terragrunt_config(find_in_parent_folders("_envcommon/common.hcl"))

  # Automatically load region-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Define as Terragrunt local vars to make it easier to use and change
  app_id           = local.common_vars.locals.app_id
  environment_name = local.env_vars.locals.environment_name
  aws_region       = local.env_vars.locals.aws_region
}

# Global TF variables input, replacing duplicate terraform.tfvars keys
inputs = merge (
  local.common_vars.locals,
  local.env_vars.locals,
)

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
  path = "providers_override.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
# In a professional setting, a hard-pin of terraform versions ensures all
# team members use the same version, reducing state conflict
terraform {
  required_version = "1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}

terraform {
  # Force Terraform to run with increased parallelism
  extra_arguments "parallelism" {
    commands = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=15"]
  }
  # Force Terraform to keep trying to acquire a lock for up to 3 minutes if someone else already has the lock
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=3m"]
  }
}