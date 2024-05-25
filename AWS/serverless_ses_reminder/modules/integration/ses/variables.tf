variable "ses_sender_email" {
  description = "The sender email address to use for SES"
  type        = string
  sensitive   = true
}

variable "ses_receiver_email" {
  description = "The receiver email address to use for SES"
  type        = string
  sensitive   = true
}
