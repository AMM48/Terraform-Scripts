variable "domain_name" {
  description = "The domain name used for certificate creation"
  type        = list(string)
  sensitive   = true
}

variable "app-alb-dns-name" {
  description = "The DNS name for the app ALB"
  type        = string
}

variable "app-alb-zone-id" {
  description = "The zone ID for the app ALB"
  type        = string
  sensitive   = true
}

variable "web-alb-dns-name" {
  description = "The DNS name for the web ALB"
  type        = string
}

variable "web-alb-zone-id" {
  description = "The zone ID for the web ALB"
  type        = string
  sensitive   = true
}

variable "dns-zone-id" {
  description = "The zone ID for the DNS zone"
  type        = string
  sensitive   = true
}
