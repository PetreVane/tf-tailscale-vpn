
variable "server_hostname" {
  description = "Server hostname"
  type        = string
  default     = "vpn"
}

variable "region" {
  description = "AWS Region"
  type = string
}

variable "tailscale_iam_role_lambda_arn" {
  type = string
  description = "The ARN of the Lambda role"
}

variable "s3_bucket_id" {
  type = string
  description = "The s3 bucked id which holds the py scripts"
}

variable "instance_start_object_id" {
  type = string
  description = "The object id of the start_instance.py script"
}

variable "instance_stop_object_id" {
  type = string
  description = "The object id of the stop_instance.py script"
}

variable "main_handler" {
  type = string
  description = "The main handler of py script"
  default = "main.handler"
}

variable "runtime" {
  description = "Python runtime"
  type = string
  default = "python3.9"
}

variable "start_instance_log_group_name" {
  type = string
  description = "The name of the CloudWatch Log Group for the start instance."
}

variable "stop_instance_log_group_name" {
  type = string
  description = "The name of the CloudWatch Log Group for the stop instance."
}

variable "event_rule_start_instance_name" {
  type = string
  description = "The name of the start instance event rule"
}

variable "event_rule_start_instance_arn" {
  description = "The arn of the start instance event rule"
}

variable "event_rule_stop_instance_name" {
  type = string
  description = "The name of the stop instance event rule"
}

variable "event_rule_stop_instance_arn" {
  type = string
  description = "The ARN of the stop instance event rule"
}
