# Project 02: AWS VPC with Bastion Host and NAT Gateway

## Overview
This project provisions a **Virtual Private Cloud (VPC)** in AWS with a secure network architecture using Terraform. It includes:
- A VPC with **public** and **private** subnets
- An **Internet Gateway (IGW)** for public subnet internet access
- A **NAT Gateway** in the public subnet for private subnet outbound connectivity
- A **Bastion Host** in the public subnet for secure SSH access
- A **Private Host** in the private subnet accessible only via the Bastion Host

## Architecture
- **VPC**: CIDR `10.0.0.0/16`
- **Public Subnet**: CIDR `10.0.1.0/24` (auto-assign public IP enabled)
- **Private Subnet**: CIDR `10.0.2.0/24`
- **Internet Gateway** attached to VPC
- **Public Route Table**: Default route `0.0.0.0/0` → IGW
- **Private Route Table**: Default route `0.0.0.0/0` → NAT Gateway
- **NAT Gateway** in public subnet with Elastic IP
- **Bastion Host**: Amazon Linux EC2 instance in public subnet
- **Private Host**: Amazon Linux EC2 instance in private subnet

## Features
- Secure SSH access to Bastion Host from your IP only
- Private Host accessible only via Bastion Host
- NAT Gateway for private subnet outbound internet access
- Tags applied to all resources for governance and cost tracking

## Prerequisites
- Terraform `>= 1.5`
- AWS CLI configured with credentials
- An existing **EC2 Key Pair** in `ca-central-1` (use its name in `key_name`)
- Your public IP in CIDR format (e.g., `107.217.98.61/32`)

## Variables
```hcl
project_name       = "tf-beginner-vpc"
region             = "ca-central-1"
az                 = "ca-central-1a"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr= "10.0.2.0/24"
allowed_ssh_cidr   = "107.217.98.61/32"
key_name           = "testaws"
bastion_instance_type = "t3.micro"
private_instance_type = "t3.micro"

# Tags
x_environment = "dev"
x_customer    = "Internal"
x_dept        = "Internal Project"
x_contact     = "test@example.com"
```

## Quick Start
1. Clone the repository:
   ```bash
   git clone https://github.com/rgjoshi24/Terraform_AWS_Projects.git
   cd Terraform_AWS_Projects/02_AWS_VPC_Bastion_NAT
   ```
2. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
   ```

## Connect to Instances
- SSH to Bastion Host:
  ```bash
  ssh -i /path/to/testaws.pem ec2-user@<bastion_public_ip>
  ```
- From Bastion Host, SSH to Private Host:
  ```bash
  ssh ec2-user@<private_host_private_ip>
  ```
- Test outbound connectivity from Private Host:
  ```bash
  ping -c 3 google.com
  ```

## Outputs
- `vpc_id`, `public_subnet_id`, `private_subnet_id`
- `internet_gateway_id`, `nat_gateway_id`
- `bastion_public_ip`, `private_host_private_ip`

## Cleanup
```bash
terraform destroy -auto-approve
```

## Notes & Best Practices
- **Key Pair name vs path**: Use the AWS key pair **name** in `key_name`. The local PEM file path is only for SSH.
- **AZ differences**: If `ca-central-1a` is unavailable, change `az` (e.g., to `ca-central-1b`).
- **Costs**: NAT Gateway incurs hourly and data processing fees; destroy resources when done.
