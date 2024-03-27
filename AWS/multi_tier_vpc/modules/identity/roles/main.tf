resource "aws_iam_role" "ec2_ssm_access_role" {
  name = "ec2-ssm-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_access_role_policy" {
  role       = aws_iam_role.ec2_ssm_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_access_profile" {
  name = "ec2-ssm-access-profile"
  role = aws_iam_role.ec2_ssm_access_role.name
}
