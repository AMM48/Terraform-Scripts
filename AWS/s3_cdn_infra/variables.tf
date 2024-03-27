variable "cf_records_map" {
  description = "map DNS records to their types"
  type        = list(map(string))
}

variable "domain_names" {
  description = "list of domain names"
  type        = list(string)
  sensitive   = true
}

variable "repository_link" {
  description = "link of the repository"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "s3 bucket name"
  type        = string
  sensitive   = true
}
