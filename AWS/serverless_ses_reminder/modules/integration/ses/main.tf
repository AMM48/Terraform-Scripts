resource "aws_ses_email_identity" "sender_email_identity" {
  email = var.ses_sender_email
}

resource "aws_ses_email_identity" "receiver_email_identity" {
  email = var.ses_receiver_email
}

