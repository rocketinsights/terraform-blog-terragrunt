# Includes the root terragrunt.hcl configurations
include "root" {
  path = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The _envcommon/app-main.hcl configuration contains
# the main application settings
# that are common across all environments (dev, qa, prod).
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/app-main.hcl"
  expose = true
}