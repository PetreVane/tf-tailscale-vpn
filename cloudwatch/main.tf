
resource "random_id" "group_log_id" {
  byte_length = 4
}

resource "random_id" "event_rule_id" {
  byte_length = 4
}


// Defines CloudWatch log groups for Lambda function start and stop logs.
resource "aws_cloudwatch_log_group" "start_instance" {
  name              = "/aws/lambda/${var.server_hostname}-${var.region}-${random_id.group_log_id.hex}-start-instance"  // Dynamically names the log group.
  retention_in_days = var.log_retention  // Sets the log retention period using a variable.
}

resource "aws_cloudwatch_log_group" "stop_instance" {
  name              = "/aws/lambda/${var.server_hostname}-${var.region}-${random_id.group_log_id.hex}-stop-instance"
  retention_in_days = var.log_retention
}

// CloudWatch event rules for instance start and stop based on a schedule.
resource "aws_cloudwatch_event_rule" "start_instance" {
  name                = "${var.server_hostname}-${var.region}-${random_id.event_rule_id.hex}-start-instance"  // Event rule name.
  schedule_expression = var.server_start_expression  // CRON or rate expression for starting.
}

resource "aws_cloudwatch_event_rule" "stop_instance" {
  name                = "${var.server_hostname}-${var.region}-${random_id.event_rule_id.hex}-stop-instance"
  schedule_expression = var.server_stop_expression
}