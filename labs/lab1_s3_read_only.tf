resource "aws_s3_bucket" "lab1_bucket" {
  bucket = "lab1-read-only-bucket-12345"
}

resource "aws_iam_user" "lab1_user" {
  name = "lab1-user"
}

resource "aws_iam_policy" "lab1_policy" {
  name        = "Lab1-S3ReadOnly"
  description = "Read-only access to one bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ReadOnlyBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetObject"]
        Resource = [
          aws_s3_bucket.lab1_bucket.arn,
          "${aws_s3_bucket.lab1_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "lab1_attach" {
  user       = aws_iam_user.lab1_user.name
  policy_arn = aws_iam_policy.lab1_policy.arn
}
