variable "web_asg_name" {
  description = "The name of the web ASG"
  type        = string
}

variable "app_asg_name" {
  description = "The name of the app ASG"
  type        = string
}

variable "app_scale_policy_out_arn" {
  description = "The ARN of the app scaling out policy"
  type        = string
  sensitive   = true
}

variable "web_scale_policy_out_arn" {
  description = "The ARN of the web scaling ou policy"
  type        = string
  sensitive   = true
}

variable "app_scale_policy_in_arn" {
  description = "The ARN of the app scaling in policy"
  type        = string
  sensitive   = true
}

variable "web_scale_policy_in_arn" {
  description = "The ARN of the web scaling in policy"
  type        = string
  sensitive   = true
}
