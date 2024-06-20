
// Defines IAM role and policy for Lambda function execution and CloudWatch logging.
resource "aws_iam_role" "tailscale_iam_role_lambda" {
  name               = "tailscale-${var.region}"
  assume_role_policy = data.aws_iam_policy_document.lambda.json  // Specifies the trust policy for assuming the role.
  tags = {
    Name = "tf-tailscale-role"
  }
}

resource "aws_iam_policy" "tailscale_iam_policy_lambda" {
  name   = "tailscale_lambda-${var.region}"
  path   = "/"
  policy = data.aws_iam_policy_document.instance.json  // Specifies the permissions policy document.
}

resource "aws_iam_policy" "tailscale_iam_policy_cloudwatch" {
  name   = "tailscale_cloudwatch-${var.region}"
  path   = "/"
  policy = data.aws_iam_policy_document.cloudwatch.json  // Permissions for logging access.
}

// Attaches IAM policies to the IAM role.
resource "aws_iam_role_policy_attachment" "tailscale_policy_attachment_lambda" {
  role       = aws_iam_role.tailscale_iam_role_lambda.name  // Associates with the Lambda IAM role.
  policy_arn = aws_iam_policy.tailscale_iam_policy_lambda.arn  // Lambda execution policy ARN.
}

resource "aws_iam_role_policy_attachment" "tailscale_policy_attachment_cloudwatch" {
  role       = aws_iam_role.tailscale_iam_role_lambda.name  // Associates with the Lambda IAM role.
  policy_arn = aws_iam_policy.tailscale_iam_policy_cloudwatch.arn  // CloudWatch logging policy ARN.
}
