resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/dbEndpoint"
  description = "The endpoint of the database"
  type        = "String"
  value       = var.db_endpoint
  data_type   = "text"
  tier        = "Standard"
}

resource "aws_ssm_parameter" "db_read_endpoint" {
  name        = "/dbReadEndpoint"
  description = "The read endpoint of the database"
  type        = "String"
  value       = var.db_read_endpoint
  data_type   = "text"
  tier        = "Standard"
}

resource "aws_ssm_parameter" "db_name" {
  name        = "/dbName"
  description = "The name of the database"
  type        = "String"
  value       = var.db_name
  data_type   = "text"
  tier        = "Standard"
}

resource "aws_ssm_parameter" "db_username" {
  name        = "/dbUsername"
  description = "The username for the database"
  type        = "String"
  value       = var.db_username
  data_type   = "text"
  tier        = "Standard"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/dbPassword"
  description = "The password for the database"
  type        = "SecureString"
  value       = var.db_password
  data_type   = "text"
  tier        = "Standard"
}
