variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "bookmarking_db"

}
variable "db_username" {
  description = "db root username"
  type        = string
}

variable "db_password" {
  description = "db root password"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain name used for certificate creation"
  type        = list(string)
  sensitive   = true
}
