/*
 Defines an IAM policy document granting permissions for AWS Lambda to assume a role.

 - **Version**: Specifies the policy language version.
 - **Statement**: Contains a single statement allowing the `lambda.amazonaws.com` service to assume a role through `sts:AssumeRole`.
 */
data "aws_iam_policy_document" "lambda" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

/*
 Creates an IAM policy document that allows starting and stopping EC2 instances.
 - **Version**: Specifies the policy language version.
 - **Statement**: Grants permissions to perform `ec2:Start*` and `ec2:Stop*` actions on all resources (`*`).
 */
data "aws_iam_policy_document" "instance" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    resources = [
      "*",
    ]

    actions = [
      "ec2:Start*",
      "ec2:Stop*",
    ]
  }
}

/*
Defines an IAM policy document for CloudWatch logging permissions.

- **Version**: Specifies the policy language version.
- **Statement**: Allows actions for creating log groups,
  log streams, and putting log events in CloudWatch, applicable to all log resources.
*/
data "aws_iam_policy_document" "cloudwatch" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    resources = [
      "arn:aws:logs:*:*:*",
    ]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}
