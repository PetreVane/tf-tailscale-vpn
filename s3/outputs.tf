

output "tailscale_s3_bucket_id" {
  description = "Tailscale bucket id"
  value = aws_s3_bucket.tailscale_s3_bucket.id
}

output "tailscale_start_instance_object_id" {
  description = "The id of the start instance script"
  value = aws_s3_object.tailscale_start_instance_object.id
}

output "tailscale_stop_instance_object_id" {
  description = "The id of the stop instance script"
  value = aws_s3_object.tailscale_stop_instance_object.id
}