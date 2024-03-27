// create CodeBuild project
resource "aws_codebuild_project" "portfolio_website" {
  name          = "portfolio-website"
  description   = "Builds the portfolio website"
  build_timeout = 5
  service_role  = var.iam_role_arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_LAMBDA_1GB"
    image        = "aws/codebuild/amazonlinux-x86_64-lambda-standard:nodejs20"
    type         = "LINUX_LAMBDA_CONTAINER"
  }
  logs_config {
    cloudwatch_logs {
      status = "DISABLED"
    }
  }
  source {
    type            = "GITHUB"
    location        = var.repository_link
    git_clone_depth = 1
    buildspec       = <<-EOF
version: 0.2

phases:
  install:
    commands:
      - echo Installing Angular CLI...
      - npm install -g @angular/cli
      - echo Installing source NPM dependencies...
      - npm install
  build:
    commands:
      - echo Build started on `date`
      - ng build

  post_build:
    commands:
      - echo Build completed on `date`
      - aws s3 sync ./dist/my-portfolio/browser/ s3://${var.s3_bucket_id} --region me-south-1 --delete
EOF
  }
  tags = {
    Name = "Portfolio Website"
  }
}

// Create Webhook for CodeBuild project
resource "aws_codebuild_webhook" "Webhook" {
  project_name = aws_codebuild_project.portfolio_website.name
  build_type   = "BUILD"
}
