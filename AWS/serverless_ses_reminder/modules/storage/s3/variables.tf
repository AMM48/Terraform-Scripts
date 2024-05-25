variable "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "step_functions_arn" {
  description = "The ARN of the Step Functions state machine"
  type        = string
  sensitive   = true
}
