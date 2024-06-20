variable "region" {
  type        = string
  description = "The region on which to deploy resources"
  default     = "eu-north-1"
}

variable "server_instance_type" {
  description = "Server instance type"
  type        = string
  default     = "t3.micro"
}

variable "tailscale_api_key" {
  description = "Tailscale API access token"
  type        = string
  sensitive   = true
}

variable "tailscale_tailnet" {
  description = "Tailscale tailnet name"
  type        = string
  sensitive   = true
}