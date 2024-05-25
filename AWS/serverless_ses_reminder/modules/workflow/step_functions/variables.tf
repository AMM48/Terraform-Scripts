variable "lambda_arn" {
  description = "The ARN of the Lambda function"
  type        = string
  sensitive   = true
}

variable "step_function_role_arn" {
  description = "The ARN of the Step Function role"
  type        = string
  sensitive   = true
}

variable "log_group_arn" {
  description = "The ARN of the CloudWatch Log Group"
  type        = string
  sensitive   = true
}
