resource "aws_iam_user" "lab5_user" {
  name = "lab4-ip-user"
}
resource "aws_s3_bucket" "lab5_secure_bucket" {
  bucket = "lab4-secure-bucket"
}

resource "aws_iam_policy" "lab5_policy" {
  name        = "Lab4-IP-Restricted-S3"
  description = "Restrict S3 access by IP"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowS3ReadOnlyFromSpecificIP"
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetObject"]
        Resource = [
          "arn:aws:s3:::lab5-secure-bucket",
          "arn:aws:s3:::lab5-secure-bucket/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.office_ip
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "lab5_attach" {
  user       = aws_iam_user.lab5_user.name
  policy_arn = aws_iam_policy.lab5_policy.arn
}
