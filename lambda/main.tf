module "cloudwatch" {
  source = "../cloudwatch"
  region = var.region
}

// Defines a Lambda function for starting EC2 instances.
resource "aws_lambda_function" "start_instance" {
  function_name = "${var.server_hostname}-${var.region}-start-instance"  // Names the function dynamically.
  role          = var.tailscale_iam_role_lambda_arn //aws_iam_role.tailscale_iam_role_lambda.arn  // Associates the IAM role for execution.
  s3_bucket     = var.s3_bucket_id //aws_s3_bucket.tailscale_s3_bucket.id  // Specifies the source bucket.
  s3_key        = var.instance_start_object_id //aws_s3_object.tailscale_start_instance_object.id  // Specifies the object key for the function code.
  handler       = var.main_handler  // The entry point in the code (handler method).
  runtime       = var.runtime  // Sets the runtime environment.
  memory_size   = 128  // Allocates memory for the function.
  timeout       = 60   // Sets the maximum execution time.

  architectures = ["arm64"]

  depends_on = [module.cloudwatch]  // Ensures log group exists before function creation.
}

// Defines a Lambda function for stopping EC2 instances.
resource "aws_lambda_function" "stop_instance" {
  function_name = "${var.server_hostname}-${var.region}-stop-instance"
  role          = var.tailscale_iam_role_lambda_arn //aws_iam_role.tailscale_iam_role_lambda.arn
  s3_bucket     = var.s3_bucket_id //aws_s3_bucket.tailscale_s3_bucket.id
  s3_key        = var.instance_stop_object_id //aws_s3_object.tailscale_stop_instance_object.id
  handler       = var.main_handler //"stop_instance.handler"
  runtime       = var.runtime
  memory_size   = 128
  timeout       = 60

  architectures = ["arm64"]

  depends_on = [module.cloudwatch]
}

// Configures CloudWatch Events to trigger the start Lambda function based on the defined schedule.
resource "aws_cloudwatch_event_target" "start_instance" {
  rule      = var.event_rule_start_instance_name //aws_cloudwatch_event_rule.start_instance.name  // Associates with the start schedule.
  target_id = var.event_rule_start_instance_name //aws_cloudwatch_event_rule.start_instance.name  // Identifies the target.
  arn       = aws_lambda_function.start_instance.arn  // Specifies the Lambda function ARN.
}

// Configures CloudWatch Events to trigger the stop Lambda function based on the defined schedule.
resource "aws_cloudwatch_event_target" "stop_instance" {
  rule      = var.event_rule_stop_instance_name //aws_cloudwatch_event_rule.stop_instance.name
  target_id = var.event_rule_stop_instance_name //aws_cloudwatch_event_rule.stop_instance.name
  arn       = aws_lambda_function.stop_instance.arn
}

// Allows the CloudWatch Events service to invoke the start instance Lambda function.
resource "aws_lambda_permission" "start_instance" {
  statement_id  = "AllowExecutionFromCloudWatch"
  principal     = "events.amazonaws.com"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_instance.function_name
  source_arn    = var.event_rule_start_instance_arn //aws_cloudwatch_event_rule.start_instance.arn
}

// Allows the CloudWatch Events service to invoke the stop instance Lambda function.
resource "aws_lambda_permission" "stop_instance" {
  statement_id  = "AllowExecutionFromCloudWatch"
  principal     = "events.amazonaws.com"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instance.function_name
  source_arn    = var.event_rule_stop_instance_arn //aws_cloudwatch_event_rule.stop_instance.arn
}
