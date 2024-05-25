resource "aws_lambda_function" "ses_lambda" {
  description   = "This Function will send an email using SES"
  function_name = "ses_lambda"
  role          = var.lambda_role_arn
  architectures = ["x86_64"]
  runtime       = "python3.12"
  handler       = "lambda.event_handler"
  filename      = "./modules/compute/lambda/lambda.zip"
  package_type  = "Zip"
  logging_config {
    log_format = "Text"
  }
  environment {
    variables = {
      SENDER_EMAIL = var.sender_email
    }
  }
}
