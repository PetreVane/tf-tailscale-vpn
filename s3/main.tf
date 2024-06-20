
resource "random_id" "bucket_id" {
  byte_length = 4
}

// Defines an S3 bucket for storing Lambda function code artifacts.
resource "aws_s3_bucket" "tailscale_s3_bucket" {
  bucket        = "${var.server_hostname}-${var.region}-${random_id.bucket_id.hex}"  // Dynamically names the bucket.
  force_destroy = true  // Allows Terraform to delete the bucket even if it contains objects.
}

// Uploads the Lambda function code for starting instances to the defined S3 bucket.
resource "aws_s3_object" "tailscale_start_instance_object" {
  bucket = aws_s3_bucket.tailscale_s3_bucket.id  // Specifies the target bucket.
  key    = "start_instance.zip"   // Names the object within the bucket.
  // Specifies the path to the local zip file containing the python code for lambda function
  source = data.archive_file.start_instance.output_path
}

// Uploads the Lambda function code for stopping instances to the S3 bucket.
resource "aws_s3_object" "tailscale_stop_instance_object" {
  bucket = aws_s3_bucket.tailscale_s3_bucket.id  // Target bucket.
  key    = "stop_instance.zip"    // Object name.
  source = data.archive_file.stop_instance.output_path  // Path to zip file.
}
