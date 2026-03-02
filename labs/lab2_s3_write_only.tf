resource "aws_s3_bucket" "lab2_bucket" {
  bucket = "lab2-write-only-bucket-12345"
}
resource "aws_iam_user" "lab2_user" {
  name = "lab2-user"
}
resource "aws_iam_policy" "lab2_write_only_policy" {
  name        = "Lab2-S3WriteOnly"
  description = "Allow write-only access to a single S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowS3PutOnly"
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.lab2_bucket.arn}/*"]
      }
    ]
  })
}
resource "aws_iam_user_policy_attachment" "lab2_attach" {
  user       = aws_iam_user.lab2_user.name
  policy_arn = aws_iam_policy.lab2_write_only_policy.arn
}
