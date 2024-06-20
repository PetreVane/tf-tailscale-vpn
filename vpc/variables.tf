
variable "region" {
  type = string
  description = "The region on which to deploy resources"
}

variable "ami_filter" {
  type = string
  description = "Filters AMIs based on the name pattern provided"
  default     = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "ami_owner" {
  type = list(string)
  description = "AMI owner is Canonical"
  default     = ["099720109477"]
}

variable "tailscale_api_key" {
  type = string
  description = "Tailscale API key"
}

variable "tailscale_tailnet" {
  type = string
  description = "Tailscale network name"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet_cidr_block" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.0.0.0/28"
}

variable "server_hostname" {
  description = "Server hostname"
  type        = string
  default     = "vpn"
}

variable "server_instance_type" {
  description = "Server instance type"
  type        = string
}

variable "server_storage_size" {
  description = "Server storage size"
  type        = number
  default     = 8
}

variable "server_storage_type" {
  description = "The type of storage"
  type = string
  default = "gp3"
}

variable "tailscale_tailnet_key_expiry" {
  description = "Tailscale tailnet key expiry"
  type        = number
  default     = 2419200
}

variable "tailscale_package_url" {
  description = "Tailscale package download URL"
  type        = string
  default     = "https://pkgs.tailscale.com/stable/ubuntu/jammy"
}

variable "timeout" {
  description = "Provision timeout"
  type        = string
  default     = "30m"
}

variable "server_username" {
  description = "AMI user"
  default     = "ubuntu"
}