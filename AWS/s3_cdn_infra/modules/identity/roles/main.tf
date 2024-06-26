// Create IAM role for CodeBuild project
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"

          Effect : "Allow"
          Principal = {
            Service = "codebuild.amazonaws.com"
          }
        }
      ]
    }
  )
}
