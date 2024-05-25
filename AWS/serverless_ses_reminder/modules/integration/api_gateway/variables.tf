variable "api_role" {
  description = "The ARN of the role to be assumed by the API Gateway"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The custom domain name of the API Gateway"
  type        = string
  sensitive   = true
}

variable "certificate_arn" {
  description = "The ARN of the certificate to be used by the API Gateway"
  type        = string
  sensitive   = true
}
