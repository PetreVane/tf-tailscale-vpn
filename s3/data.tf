

data "archive_file" "start_instance" {
  type            = "zip"
  source_file     = "${path.module}/start_instance.py"
  output_path     = "${path.module}/start_instance.zip"
}

data "archive_file" "stop_instance" {
  type        = "zip"
  source_file = "${path.module}/stop_instance.py"
  output_path = "${path.module}/stop_instance.zip"
}