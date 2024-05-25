variable "domain_name" {
  description = "The domain name of the Route 53 hosted zone"
  type        = string
  sensitive   = true
}

variable "api_dns_name" {
  description = "The DNS name of the API Gateway"
  type        = string
  sensitive   = true
}

variable "api_zone_id" {
  description = "The zone ID of the API Gateway"
  type        = string
  sensitive   = true
}

variable "cloudfront_dns_name" {
  description = "The DNS name of the CloudFront distribution"
  type        = string
  sensitive   = true
}

variable "cloudfront_zone_id" {
  description = "The zone ID of the CloudFront distribution"
  type        = string
  sensitive   = true
}
