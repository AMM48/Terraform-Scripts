variable "db_name" {
  description = "The name of the database"
  type        = string
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

variable "subnets" {
  description = "The subnets to use for the RDS instance"
  type        = any
}

variable "db-sg" {
  description = "The security group to use for the RDS instance"
  type        = list(string)
}
