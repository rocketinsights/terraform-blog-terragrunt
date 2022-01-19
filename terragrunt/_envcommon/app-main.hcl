# This is the common component configuration for main application in all environments (dev, qa, prod).

# Locals are named constants that are reusable within the configuration.
locals {
  # Load common.hcl to get base_module_source_url
  # Unfortunately a bit of duplication with the root terragrunt.hcl locals
  # since Terragrunt does not let the child terragrunt.hcl access the parent locals block
  env_vars = read_terragrunt_config(find_in_parent_folders("_envcommon/common.hcl"))

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_module_source_url = local.env_vars.locals.base_module_source_url
  module_source_url = "${local.base_module_source_url}/app-main"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  # No need to uncomment anything for local development
  # terragrunt apply --terragrunt-source=../../..//modules/app-main
  source = "${local.module_source_url}?ref=main"
}

# The app-main module is dependent on both the vpc and IAM modules completing first
# By defining dependencies, Terragrunt run-all will run the Terraform modules in the correct order.
# Without Terragrunt, you would have to hard-code the execution order of the Terraform module
# in a Bash script
dependencies {
  paths = ["../vpc", "../iam"]
}