resource "aws_iam_role" "ec2_role" {
  name = "${var.app_id}_ec2_role_${var.environment_name}"
  path = "/${var.project_name}/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  # I prefer jsonencode over the Terraform data "aws_iam_policy_document"
  # because the jsonencode syntax is closer to what AWS UI uses
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}