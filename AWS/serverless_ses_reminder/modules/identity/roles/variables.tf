variable "ses_identity_arn" {
  description = "The ARN of the SES email identity"
  type        = list(string)
  sensitive   = true
}

variable "lambda_arn" {
  description = "The ARN of the Lambda function"
  type        = string
  sensitive   = true
}

variable "sfn_arn" {
  description = "The ARN of the Step Function"
  type        = string
  sensitive   = true
}

