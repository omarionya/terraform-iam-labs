resource "aws_s3_bucket" "upload_bucket" {
  bucket = "lab3-upload-delete-bucket-12345"
}
resource "aws_iam_user" "upload_user" {
  name = "lab-upload-user"
}

resource "aws_iam_policy" "upload_policy" {
  name = "Lab-Upload-NoDelete"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [

      # Allow Upload + Read
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.upload_bucket.arn,
          "${aws_s3_bucket.upload_bucket.arn}/*"
        ]
      },

      # Explicitly Deny Delete
      {
        Effect = "Deny",
        Action = [
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.upload_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "upload_attach" {
  user       = aws_iam_user.upload_user.name
  policy_arn = aws_iam_policy.upload_policy.arn
}
