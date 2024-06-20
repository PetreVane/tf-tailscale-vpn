

# Automated Tailscale VPN deployment 

This Terraform project sets up a robust Tailscale VPN on AWS, with automated EC2 instance management using Lambda functions, triggered by CloudWatch Events. The setup includes IAM roles, S3 buckets for Lambda function storage, CloudWatch log groups, and event rules.

## Project Structure

- **main.tf**: Entry point for the Terraform configuration, setting up providers, modules, and other resources.
- **variables.tf**: Defines the variables used throughout the project.
- **terraform.auto.tfvars**: Contains sensitive information such as Tailscale API key and the network name. You need to add this yourself with your Tailscale api key and network name 
- **versions.tf**: Specifies the required providers and their versions.
- **data.tf**: Data sources for fetching external data.
- **outputs.tf**: Defines the output variables that provide information about the resources created.
- **scripts**:
  - **tailscale_setup.sh.tpl**: Tailscale setup script template.
  - **start_instance.py**: Python script for Lambda function to start EC2 instances.
  - **stop_instance.py**: Python script for Lambda function to stop EC2 instances.
- **modules**:
  - **cloudwatch**: Sets up CloudWatch log groups and event rules.
  - **iam**: Defines IAM roles and policies for Lambda execution and CloudWatch logging.
  - **lambda**: Configures Lambda functions and their triggers.
  - **s3**: Manages S3 buckets for storing Lambda function code artifacts.
  - **vpc**: Creates a VPC with subnets, route tables, internet gateways, and security groups.

## Modules Overview

### CloudWatch

This module sets up the necessary CloudWatch resources, including:
- Log groups for Lambda functions.
- Event rules to trigger the Lambda functions based on a schedule.

### IAM

The IAM module defines roles and policies necessary for:
- Lambda functions to start and stop EC2 instances.
- CloudWatch to log events and invoke Lambda functions.

### Lambda

This module configures the Lambda functions responsible for:
- Starting EC2 instances (`start_instance.py`).
- Stopping EC2 instances (`stop_instance.py`).
It also sets up the necessary permissions and triggers (CloudWatch events).

### S3

The S3 module manages S3 buckets which store the Lambda function code artifacts. It includes:
- Creation of the S3 bucket.
- Uploading Lambda function code (`start_instance.py` and `stop_instance.py`) to the bucket.

### VPC

The VPC module creates a Virtual Private Cloud (VPC) with:
- Subnets
- Route tables
- Internet gateways
- Security groups for controlled access to the instances.

## Prerequisites

Before getting started, ensure you have the following:

- Terraform installed (v1.0.0 or newer)
- AWS CLI installed and configured
- AWS credentials with sufficient permissions
- Python 3.7+ (for Lambda functions)

## Installation and Setup

### Step 1: Install Terraform

#### macOS
```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### Windows
Download the terraform binary from the [Terraform Downloads](https://www.terraform.io/downloads.html) page and add it to your system's PATH.

#### Linux
```sh
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
```

Verify the installation:
```sh
terraform -help
```

### Step 2: Configure AWS CLI

[Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html):

```sh
pip install awscli
```

Configure AWS CLI with your credentials:
```sh
aws configure
```

### Step 3: Clone the Repository

```sh
git clone https://github.com/PetreVane/tf-tailscale-vpn.git
cd tf-tailscale-vpn
```

### Step 4: Setup Variables
- Update the `variables.tf` file at the root of the project, with the region in which you want to deploy this solution. Make sure the `server_instance_type` variable matches the available instance type in your region.
- Create a `terraform.auto.tfvars` file at the root of your project with the following content:

```hcl
tailscale_api_key = "your-tailscale-api-key"
tailscale_tailnet = "your-tailscale-tailnet"
```

### Step 5: Initialize Terraform

```sh
terraform init
```

### Step 6: Managing Workspaces

Please note that, this project can have multiple branches, named by the regions in which you can deploy this solution.

The *variables.tf* file which resides at the root of the project, contains a variable named *region* which has a default value set to **eu-north-1**.

Terraform workspaces allows you to manage separate state files for different environments or branches. Here’s how to create and switch between workspaces:

#### List Existing Workspaces

```sh
terraform workspace list
```

#### Create a New Workspace

```sh
terraform workspace new <workspace-name>
```

For each branch, you can create and initialize a corresponding workspace. For example:

```sh
terraform workspace new eu-north-1
terraform workspace new eu-central-1
terraform workspace new ap-south-1
```

#### Switch to an Existing Workspace

```sh
terraform workspace select <workspace-name>
```

Ensure you're on the correct Git branch and switch to its corresponding Terraform workspace before running any commands.

### Step 7: Plan and Apply

#### Plan the Infrastructure Changes
```sh
terraform plan
```

#### Apply the Changes to Create the Infrastructure
```sh
terraform apply
```

**Note**: Replace  `your-tailscale-api-key`, and `your-tailscale-tailnet` with your actual values.

## AWS Resources Overview

- **VPC and Subnets**: A Virtual Private Cloud (VPC) with a subnet for hosting the EC2 instance.
- **Security Groups**: Defines rules for inbound and outbound traffic to the instances.
- **EC2 Instances**: Managed Tailscale VPN instances with user data for setup.
- **IAM Roles and Policies**: IAM roles and policies for Lambda execution and CloudWatch logging.
- **S3 Buckets**: For storing Lambda function code artifacts.
- **Lambda Functions**: Python-based AWS Lambda functions to start and stop EC2 instances.
- **CloudWatch**: Log groups and event rules to trigger Lambda functions based on a schedule.

## Tailscale Setup

Tailscale provides a secure, easy-to-setup network using WireGuard under the hood. You will have to create an account on  [Tailscale](https://tailscale.com) and generate an api key. The Tailscale setup script (`tailscale_setup.sh.tpl`) will configure the VPN connection for the EC2 instances. Remember to provide the `tailscale_api_key` and `tailscale_tailnet` when running the Terraform apply command.
## Monitoring & Logging

All actions executed by the Lambda functions (start/stop EC2 instances) are logged in CloudWatch Log Groups, ensuring you can trace and debug the automation behavior.

## Cleaning Up

To destroy the infrastructure and avoid any costs:
```sh
terraform destroy
```

## Contributing

Feel free to fork this repository and make contributions. To contribute:

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add cool feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a new Pull Request

---

Feel free to reach out for any questions or suggestions!

