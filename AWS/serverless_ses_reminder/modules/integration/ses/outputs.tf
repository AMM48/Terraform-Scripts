output "ses_identity_arns" {
  value = [
    aws_ses_email_identity.sender_email_identity.arn,
  aws_ses_email_identity.receiver_email_identity.arn]
  sensitive = true
}

output "sender_email" {
  value     = aws_ses_email_identity.sender_email_identity.email
  sensitive = true
}
