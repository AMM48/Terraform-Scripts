// Create IAM role policy for CodeBuild project 
resource "aws_iam_role_policy" "codebuild_role_policy" {
  name = "codebuild_role_policy"
  role = var.codebuild_role_id

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Resource = [
            "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}",
            "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.codebuild_project_name}:*"
          ],
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          Effect = "Allow",
          Resource = [
            var.s3_bucket_arn,
            "${var.s3_bucket_arn}/*"
          ],
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:DeleteObject"
          ]
        },
      ]
    }
  )
}

data "aws_caller_identity" "current" {}
