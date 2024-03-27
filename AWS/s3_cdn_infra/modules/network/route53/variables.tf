variable "domain_names" {
  description = "list of domain names"
  type        = list(string)
}

variable "cloudfront_distribution_domain_name" {
  description = "cloudfront distribution domain name"
  type        = string
}

variable "cloudfront_distribution_hosted_zone_id" {
  description = "cloudfront distribution hosted zone id"
  type        = string
}

variable "cf_records_map" {
  description = "map DNS records to their types"
  type        = list(map(string))
}

variable "dns_zone_id" {
  description = "The zone ID for the DNS zone"
  type        = string
}
