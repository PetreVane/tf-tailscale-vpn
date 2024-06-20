

// Defines an AWS VPC (Virtual Private Cloud) with a specified CIDR block.
resource "aws_vpc" "tailscale_vpc" {
  cidr_block = var.vpc_cidr_block  // Sets the CIDR block for the VPC, using a variable.
  tags = {
    Name = "tf-tailscale-vpc"
  }
}

// Defines an AWS subnet within the VPC.
resource "aws_subnet" "tailscale_subnet" {
  vpc_id            = aws_vpc.tailscale_vpc.id  // Associates the subnet with the VPC defined above.
  cidr_block        = var.subnet_cidr_block // Sets the CIDR block for the subnet.
  availability_zone = "${var.region}a"  // Specifies the availability zone for the subnet.
  tags = {
    Name = "tf-tailscale-subnet"
  }
}

// Creates an Internet Gateway and associates it with the VPC for allowing internet access.
resource "aws_internet_gateway" "tailscale_igw" {
  vpc_id = aws_vpc.tailscale_vpc.id  // The ID of the VPC.
  tags = {
    Name = "tf-tailscale-igw"
  }
}


// Creates a route table for the VPC and defines a route for outbound internet access via the internet gateway.
resource "aws_route_table" "tailscale_rt" {
  vpc_id = aws_vpc.tailscale_vpc.id  // Associates the route table with the VPC.

  route {
    cidr_block = "0.0.0.0/0" // The CIDR block defining all IP addresses.
    gateway_id = aws_internet_gateway.tailscale_igw.id  // The ID of the internet gateway for routing.
  }
  tags = {
    Name = "tf-tailscale-rt"
  }
}

// Associates the route table with a specific subnet, enabling the subnet to use the routes defined.
resource "aws_route_table_association" "tailscale_rt_assoc" {
  route_table_id = aws_route_table.tailscale_rt.id  // The ID of the route table.
  subnet_id      = aws_subnet.tailscale_subnet.id       // The ID of the subnet to associate.
}

// Specifies a security group to control inbound and outbound traffic for instances.
resource "aws_security_group" "tailscale_sg" {
  name   = "${var.server_hostname}-${var.region}"  // Dynamically names the security group using variables.
  vpc_id = aws_vpc.tailscale_vpc.id  // Associates the security group with the previously defined VPC.

  // Defines inbound rule allowing SSH access. -  purposely commented out: no need for ssh anymore but kept just in case
#   ingress {
#     description = "SSH"  // Descriptive label for the rule.
#     from_port   = 22     // The starting port of the rule (SSH standard port).
#     to_port     = 22     // The ending port of the rule.
#     protocol    = "tcp"  // The protocol used (SSH uses TCP).
#     cidr_blocks = ["0.0.0.0/0"]  // Allows access from any IP address.
#   }

  // Defines outbound rule allowing all traffic out.
  egress {
    from_port   = 0    // Indicates all ports.
    to_port     = 0    // Indicates all ports.
    protocol    = "-1" // Indicates all protocols.
    cidr_blocks = ["0.0.0.0/0"] // Allows access to any IP address.
  }

  tags = {
    Name = "tf-tailscale-sg"
  }
}

// Generates a RSA private key for use in SSH and other secure communications.
resource "tls_private_key" "tailscale_private_key" {
  algorithm = "RSA"  // Specifies the algorithm for the key generation.
  rsa_bits  = 4096   // Defines the key size for RSA, increasing security.
}

resource "random_id" "key_id" {
  byte_length = 4
}

// Creates an AWS Key Pair using the generated RSA public key, for SSH access to instances.
resource "aws_key_pair" "tailscale_key_pair" {
  key_name   = "${var.server_hostname}-${var.region}-${random_id.key_id.hex}"  // Names the key pair dynamically.
  public_key = tls_private_key.tailscale_private_key.public_key_openssh  // Uses the OpenSSH format public key from the TLS resource.
  tags = {
    Name = "tf-tailscale-key-pair"
  }
}

// Stores the RSA private key securely in AWS Systems Manager Parameter Store.
resource "aws_ssm_parameter" "tailscale_ssm_parameter" {
  name  = "/tailscale/${var.server_hostname}-${var.region}-${random_id.key_id.hex}"  // Names the parameter for organization.
  type  = "SecureString"  // Specifies that the value is encrypted.
  value = tls_private_key.tailscale_private_key.private_key_pem  // Stores the PEM format RSA private key.
}

// Reads the content of tailscale_setup.sh.tpl script
data "template_file" "tailscale_userdata" {
  template = file("${path.root}/tailscale_setup.sh.tpl")

  vars = {
    hostname = var.server_hostname
    region   = var.region
    authkey  = tailscale_tailnet_key.this.key
  }
}

// Defines an AWS instance, specifying its size, image, and network settings.
resource "aws_instance" "tailscale_ec2" {
  ami           = data.aws_ami.this.id  // Specifies the AMI ID for the instance (defined elsewhere).
  instance_type = var.server_instance_type  // Sets the instance type using a variable.
  subnet_id     = aws_subnet.tailscale_subnet.id  // Associates the instance with a specific subnet.
  key_name      = aws_key_pair.tailscale_key_pair.key_name  // Associates the SSH key for instance access.

  vpc_security_group_ids = [aws_security_group.tailscale_sg.id]  // Associates the instance with the defined security group.
  associate_public_ip_address = true

  // Configures the root block device of the instance.
  root_block_device {
    volume_size = var.server_storage_size  // Sets the volume size using a variable.
    volume_type = "gp3"
  }

  user_data = data.template_file.tailscale_userdata.rendered

  tags = {
    Name = "tf-tailscale-server"
  }
}

// Generates a Tailscale Tailnet Key for secure networking between instances.
resource "tailscale_tailnet_key" "this" {
  reusable      = true  // Allows the key to be reused.
  preauthorized = true  // Automatically authorizes devices using this key.
  expiry        = var.tailscale_tailnet_key_expiry  // Configures the expiration of the key.
}

