
output "start_instance_log_group_name" {
  value = aws_cloudwatch_log_group.start_instance.name
  description = "The name of the CloudWatch Log Group for the start instance."
}

output "start_instance_log_group_arn" {
  value = aws_cloudwatch_log_group.start_instance.arn
  description = "The ARN of the CloudWatch Log Group for the start instance."
}


output "stop_instance_log_group_name" {
  value = aws_cloudwatch_log_group.stop_instance.name
  description = "The name of the CloudWatch Log Group for the stop instance."
}

output "stop_instance_log_group_arn" {
  value = aws_cloudwatch_log_group.stop_instance.arn
  description = "The ARN of the CloudWatch Log Group for the stop instance."
}

output "event_rule_start_instance_name" {
  value = aws_cloudwatch_event_rule.start_instance.name
  description = "The name of the start instance event rule"
}

output "event_rule_start_instance_arn" {
  value = aws_cloudwatch_event_rule.start_instance.arn
  description = "The arn of the start instance event rule"
}


output "event_rule_stop_instance_name" {
  value = aws_cloudwatch_event_rule.stop_instance.name
  description = "The name of the stop instance event rule"
}

output "event_rule_stop_instance_arn" {
  value = aws_cloudwatch_event_rule.stop_instance.arn
  description = "The arn of the stop instance event rule"
}
