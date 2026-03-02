resource "aws_iam_policy" "lab6_policy" {
  name        = "Lab5-RequireMFA"
  description = "Allow EC2 actions only with MFA"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "RequireMFAForEC2"
        Effect   = "Allow"
        Action   = ["ec2:StartInstances", "ec2:StopInstances", "ec2:DescribeInstances"]
        Resource = "*"
        Condition = {
          Bool = { "aws:MultiFactorAuthPresent" = "true" }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "lab6_attach" {
  user       = var.mfa_user_name //user with mfa device configured
  policy_arn = aws_iam_policy.lab6_policy.arn
}
