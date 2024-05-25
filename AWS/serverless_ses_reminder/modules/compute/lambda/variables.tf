variable "lambda_role_arn" {
  description = "The ARN of the Lambda role"
  type        = string
  sensitive   = true
}

variable "sender_email" {
  description = "The email address of the sender"
  type        = string
  sensitive   = true
}
