resource "aws_iam_user" "amplify_user" {
  name = "amplify-deployer"
  tags = {
    Purpose = "Amplify CLI access"
  }
}

resource "aws_iam_policy" "amplify_policy" {
  name        = "AmplifyFullAccessPolicy"
  description = "Policy for managing Amplify projects and resources"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "amplify:*",
          "appsync:*",
          "cloudformation:*",
          "cognito-idp:*",
          "cognito-identity:*",
          "dynamodb:*",
          "iam:GetRole",
          "iam:PassRole",
          "lambda:*",
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "amplify_policy_attachment" {
  user       = aws_iam_user.amplify_user.name
  policy_arn = aws_iam_policy.amplify_policy.arn
}
