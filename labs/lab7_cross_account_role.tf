resource "aws_s3_bucket" "lab7_bucket" {
  bucket = "lab7-secure-cross-account-bucket-12345"
}

resource "aws_iam_role" "lab7_cross_role" {
  name = "Lab7-CrossAccountRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${var.account_b_id}:user/${var.user_b_name}" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lab7_policy" {
  name        = "Lab7-S3ReadAccess"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetObject"]
        Resource = ["arn:aws:s3:::${aws_s3_bucket.lab7_bucket.bucket}", "arn:aws:s3:::${aws_s3_bucket.lab7_bucket.bucket}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lab7_attach" {
  role       = aws_iam_role.lab7_cross_role.name
  policy_arn = aws_iam_policy.lab7_policy.arn
}
