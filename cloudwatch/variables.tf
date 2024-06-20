variable "region" {
  description = "AWS region"
  type        = string
}

variable "server_hostname" {
  description = "Server hostname"
  type        = string
  default     = "vpn"
}

variable "log_retention" {
  description = "CloudWatch log retention"
  type        = number
  default     = 14
}

variable "server_start_expression" {
  description = "Server start schedule expression"
  type        = string
  default     = "cron(0 10 * * ? *)"
}

variable "server_stop_expression" {
  description = "Server stop schedule expression"
  type        = string
  default     = "cron(0 1 * * ? *)"
}