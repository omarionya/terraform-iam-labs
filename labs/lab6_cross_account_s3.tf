########################################
# S3 Bucket (Account A)
########################################

resource "aws_s3_bucket" "cross_account_bucket" {
  bucket = "lab6-cross-account-bucket-12345"
}

########################################
# IAM Role (Account A)
# Trusted by Account B user
########################################

resource "aws_iam_role" "cross_account_role" {
  name = "Lab6-CrossAccountRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_b_id}:user/${var.user_b_name}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

########################################
# IAM Policy (S3 Access)
########################################

resource "aws_iam_policy" "cross_account_policy" {
  name        = "Lab6-CrossAccountS3Policy"
  description = "Allow read/write on one bucket from Account B"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3ReadWrite"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.cross_account_bucket.arn,
          "${aws_s3_bucket.cross_account_bucket.arn}/*"
        ]
      }
    ]
  })
}

########################################
# Attach Policy to Role
########################################

resource "aws_iam_role_policy_attachment" "cross_attach" {
  role       = aws_iam_role.cross_account_role.name
  policy_arn = aws_iam_policy.cross_account_policy.arn
}