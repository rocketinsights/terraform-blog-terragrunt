# This is the common component configuration for IAM in all environments (dev, qa, prod).

# Locals are named constants that are reusable within the configuration.
locals {
  # Load common.hcl to get base_module_source_url
  # Unfortunately a bit of duplication with the root terragrunt.hcl locals
  # since Terragrunt does not let the child terragrunt.hcl access the parent locals block
  env_vars = read_terragrunt_config(find_in_parent_folders("_envcommon/common.hcl"))

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  base_module_source_url = local.env_vars.locals.base_module_source_url
  module_source_url = "${local.base_module_source_url}/env-iam"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  # No need to uncomment anything for local development
  # terragrunt apply --terragrunt-source=../../..//modules/env-iam
  source = "${local.module_source_url}?ref=main"
}

# Terragrunt dependency and dependencies blocks are different.
# The dependency block is for using the output values of a dependent Terragrunt module
# https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#passing-outputs-between-modules
# The dependencies block is to ensure Terragrunt run-all executes the apply in the correct module order
# https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules
dependency "lookup_s3_module" {
  config_path = "${get_original_terragrunt_dir()}/../s3"

  # Mock outputs are for when the state of the dependency module is not created yet
  # This way "terragrunt validate" will not fail from missing state
  mock_outputs = {
    vpc_id = "mock-s3-bucket-name"
  }
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs_merge_with_state = true
  skip_outputs = false
}

# This is an example of both using the above dependency block outputs and
# overriding the inputs value from the root terragrunt.hcl
inputs = {
  bucket_name = dependency.lookup_s3_module.outputs.id
}

# The IAM module is dependent on the S3 module completing first
# By defining dependencies, Terragrunt will run the Terraform modules in the correct order.
# Without Terragrunt, you would have to hard-code the execution order of the Terraform module
# in a Bash script
dependencies {
  paths = ["../s3"]
}