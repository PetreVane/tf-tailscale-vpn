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
      version = "0.16.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "tailscale" {
  api_key = var.tailscale_api_key
}

module "vpc" {
  source               = "./vpc"
  region               = var.region
  server_instance_type = var.server_instance_type
  tailscale_api_key    = var.tailscale_api_key
  tailscale_tailnet    = var.tailscale_tailnet

  providers = {
    aws       = aws
    tailscale = tailscale
  }
}

module "iam" {
  source = "./iam"
  region = var.region
}

module "cloudwatch" {
  source = "./cloudwatch"
  region = var.region
}

module "s3" {
  source = "./s3"
  region = var.region
}

module "lambda" {
  source                         = "./lambda"
  region                         = var.region
  tailscale_iam_role_lambda_arn  = module.iam.tailscale_iam_role_lambda_arn
  s3_bucket_id                   = module.s3.tailscale_s3_bucket_id
  instance_start_object_id       = module.s3.tailscale_start_instance_object_id
  instance_stop_object_id        = module.s3.tailscale_stop_instance_object_id
  start_instance_log_group_name  = module.cloudwatch.start_instance_log_group_name
  stop_instance_log_group_name   = module.cloudwatch.stop_instance_log_group_name
  event_rule_start_instance_arn  = module.cloudwatch.event_rule_start_instance_arn
  event_rule_start_instance_name = module.cloudwatch.event_rule_start_instance_name
  event_rule_stop_instance_arn   = module.cloudwatch.event_rule_stop_instance_arn
  event_rule_stop_instance_name  = module.cloudwatch.event_rule_stop_instance_name
}
