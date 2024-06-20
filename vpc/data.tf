/*
 This data source is used to fetch the most recent Amazon Machine Image (AMI) that matches the specified filters.

 - **Filter by Name**: Filters AMIs based on the name pattern provided in `var.ami_filter`.
 - **Filter by Virtualization Type**: Filters AMIs that are using HVM virtualization.
 - **Owners**: Specifies the owner of the AMI, which is provided in `var.ami_owner`.
 - **Most Recent**: Ensures that only the most recent AMI is selected.
 */
data "aws_ami" "this" {
  most_recent = true
  owners = var.ami_owner

  filter {
    name = "name"

    values = [
      var.ami_filter,
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm",
    ]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
