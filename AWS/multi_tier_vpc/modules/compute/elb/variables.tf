variable "vpc-id" {
  description = "The VPC ID"
  type        = string
  sensitive   = true
}

variable "subnets" {
  description = "The subnets to use for the ELB"
  type        = any
}

variable "web-alb-sg" {
  description = "The security group to use for the web ALB"
  type        = list(string)
}

variable "app-alb-sg" {
  description = "The security group to use for the app ALB"
  type        = list(string)
}

variable "acm-cert-arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  sensitive   = true
}
