resource "aws_iam_role" "ec2_role" {
  name        = "${var.app_id}-ec2-role-${var.environment_name}"
  path        = "/${var.project_name}/"
  description = "Role for EC2 for app ${var.app_id} in ${var.environment_name}"

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

resource "aws_iam_policy" "app_s3_access" {
  name        = "${var.app_id}_app_s3_policy_${var.environment_name}"
  path        = "/${var.project_name}/"
  description = "Policy for S3 access for app ${var.app_id} in ${var.environment_name}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = [data.aws_s3_bucket.app_s3_bucket.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = ["${data.aws_s3_bucket.app_s3_bucket.arn}/*"]
      }
    ]
  })
}

# aws_iam_policy_attachment has clunky production usage over detaching policies
# and exclusive attachments.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
# Prefer the use of aws_iam_role_policy_attachment instead
resource "aws_iam_role_policy_attachment" "ec2_role_attach_ssm_access" {
  role       = aws_iam_role.ec2_role.id
  policy_arn = data.aws_iam_policy.ssm_access.arn
}

resource "aws_iam_role_policy_attachment" "ec2_role_attach_s3_access" {
  role       = aws_iam_role.ec2_role.id
  policy_arn = aws_iam_policy.app_s3_access.arn
}