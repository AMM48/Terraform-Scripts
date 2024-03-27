variable "domain_names" {
  description = "list of domain names"
  type        = list(string)
}

variable "s3_bucket_regional_domain_name" {
  description = "s3 bucket regional domain name"
  type        = string
}

variable "s3_bucket" {
  description = "s3 bucket"
  type        = any
}

variable "acm_certificate" {
  description = "acm certificate"
  type        = any
}
