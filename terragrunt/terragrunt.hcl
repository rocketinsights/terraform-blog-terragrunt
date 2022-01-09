# The root terragrunt.hcl containing the configuration applicable to all environments (dev, qa, prod)

# Locals are named constants that are reusable within the configuration.
# Loading the common and env variables
locals {
  # Automatically load variables common to all environments (dev, qa, prod)
  common_vars = read_terragrunt_config(find_in_parent_folders("_envcommon/common.hcl"))

  # Automatically load environment -level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Define as Terragrunt local vars to make it easier to use and change
  project_name     = local.common_vars.locals.project_name
  app_id           = local.common_vars.locals.app_id
  environment_name = local.env_vars.locals.environment_name
  aws_region       = local.env_vars.locals.aws_region
}

# Using the common and env variables as input for the Terraform modules
# Replaces duplicate terraform.tfvars files and Terraform modules configuration
inputs = merge (
  local.common_vars.locals,
  local.env_vars.locals,
)

# Common Terraform remote state that can be reused by all modules
# Replaces duplicate providers.tf terraform backend
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
# In Terraform, changing these provider settings and versions results in changing multiple providers.tf
# In Terragrunt, this root terragrunt.hcl is the only place you need to make the change
generate "provider" {
  # This is using the Terraform built-in override file functionality
  # https://www.terraform.io/language/files/override
  path = "providers_override.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
# In a professional setting, a hard-pin of terraform versions ensures all
# team members use the same version, reducing state conflict
terraform {
  required_version = "1.1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}
provider "aws" {
  region = "${local.aws_region}"

  # See info about default_tags at
  # https://blog.rocketinsights.com/best-practices-for-terraform-aws-tags/
  default_tags {
    tags = {
      project     = "${local.project_name}"
      app-id      = "${local.app_id}"
      environment = "${local.environment_name}"

      // This tag helps AWS UI users discover what
      // Terragrunt git repo and directory to modify
      // No need for an awkward regex like in Terraform
      terragrunt-base-path = "${local.project_name}/terragrunt/${path_relative_to_include()}"
    }
  }
}
EOF
}

terraform {
  # Terragrunt extra_arguments sets Terraform options in one place
  # To do this in Terraform would require a custom bash script

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