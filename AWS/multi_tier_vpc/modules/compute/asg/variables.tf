variable "domain_name" {
  description = "The domain name"
  type        = list(string)
  sensitive   = true
}

variable "web-sg" {
  description = "The security group to use for the web instances"
  type        = list(string)
}

variable "app-sg" {
  description = "The security group to use for the app instances"
  type        = list(string)
}

variable "subnets" {
  description = "The subnets to use for the ELB"
  type        = any
}

variable "web-tg-arn" {
  description = "The ARN of the target group for the web instances"
  type        = list(string)
  sensitive   = true
}

variable "app-tg-arn" {
  description = "The ARN of the target group for the app instances"
  type        = list(string)
  sensitive   = true
}

variable "instance_profile_arn" {
  description = "The instance profile arn"
  type        = string
}
