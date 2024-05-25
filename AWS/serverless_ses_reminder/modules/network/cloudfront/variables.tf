variable "domain_name" {
  description = "The domain name of the CloudFront distribution"
  type        = list(string)
}

variable "s3_bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ACM certificate arn to use for the CloudFront distribution"
  type        = string
}

variable "s3_bucket" {
  description = "The S3 bucket to associate with the CloudFront distribution"
  type        = any
}
