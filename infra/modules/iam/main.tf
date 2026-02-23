resource "aws_iam_role" "my_iam" {
  name = "${var.environment}-lambda-role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  
}

resource "aws_iam_policy" "my_policy" {
  name        = "${var.environment}_test_policy"
  path        = "/"
  description = "My  policy"


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my-attach" {
  role       = aws_iam_role.my_iam.name
  policy_arn = aws_iam_policy.my_policy.arn
}