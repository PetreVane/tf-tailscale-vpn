terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "~> 0.16.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
