# Benefits of Terragrunt

[Terragrunt](https://terragrunt.io/) is an enhancement for [Terraform](https://terraform.io/) that provides two main benefits
* Avoid duplication of Terraform code
* Simplify command line usage

Introducing an additional DevOps tool can be a time-consuming effort, especially to an existing Terraform codebase.
This article will help you make an informed cost-benefit decision whether Terragrunt is a correct choice for your business.

The Rocket Insights DevOps practice believes that the benefits of clean code, easier configuration, and ease of use 
outweighs the cost of introducing Terragrunt into the tool chain.

## DRY (Don't Repeat Yourself)
DRY (Don't Repeat Yourself) is a fundamental computer programming principle of avoiding the duplication of code
in multiple places. If code is copied into different sections, when it comes time to modify the that code, you will 
have to change it in multiple sections. Most likely you will miss updating a section and cause bugs.
A better approach is to define the code in one place and reuse it. This way there is only one place to
make the change. (NOTE: Too wordy stream of consciousness. Trim it down)

The GitHub example code for this article has numerous comments highlighting the benefits to Terragrunt.

### DRY variables
### DRY configurations
### DRY remote state
### DRY CLI parameters

## Ease of Use
### run-all
### Auto-create remote state resources
### Before/After hooks

## Terragrunt Alternative
### Workspaces
### Symlinks

Terragrunt benefits:
Keep config DRY
Easy to see scope of variables
Auto create TF S3/DynamoDB
Usability . only edit common.hcl and env.hcl

Not a big fan of workspaces
Git symlinks are kludgy and don't work well on Windows
no terragrunt init