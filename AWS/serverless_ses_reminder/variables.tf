variable "sender_email" {
  description = "The email address of the sender"
  type        = string
  sensitive   = true
}

variable "receiver_email" {
  description = "The email address of the receiver"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  sensitive   = true
}
