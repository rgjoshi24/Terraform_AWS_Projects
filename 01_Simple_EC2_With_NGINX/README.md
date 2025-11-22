# Project 01: Simple EC2 With NGINX

## Overview
This project provisions a single **Amazon EC2** instance running **Amazon Linux** and installs the **NGINX** web server using Terraform. It demonstrates how to use Terraform to deploy a basic compute resource and configure it using `user_data`.

## Features
- Launches an EC2 instance in a specified AWS region.
- Installs NGINX automatically using cloud-init `user_data`.
- Creates a Security Group allowing inbound **HTTP (port 80)** and **SSH (port 22)**.
- Outputs the instance **public IP** for easy access.

## Architecture
A simple architecture:
- **EC2 Instance**: Amazon Linux
- **Security Group**: Allows HTTP and SSH
- **NGINX** installed via `user_data`

## Prerequisites
- Terraform `>= 1.5`
- AWS CLI configured with credentials
- An existing **EC2 Key Pair** in the target region (for SSH), referenced by its **key pair name** (not the local `.pem` path)

## Quick Start
1. Clone the repository:
   ```bash
   git clone https://github.com/rgjoshi24/Terraform_AWS_Projects.git
   cd Terraform_AWS_Projects/01_Simple_EC2_With_NGINX
   ```
2. Initialize and apply:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
3. Access NGINX:
   ```
   http://<instance_public_ip>
   ```

## Example Variables
```hcl
region        = "ca-central-1"
instance_type = "t3.micro"
key_name      = "<your-ec2-keypair-name>"
```

## Outputs
```hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
}
```

## Cleanup
```bash
terraform destroy -auto-approve
```

## Notes & Best Practices
- Ensure your **key pair** exists in AWS (e.g., `testaws`), and SSH with the corresponding local PEM file:
  ```bash
  ssh -i /path/to/testaws.pem ec2-user@<instance_public_ip>
  ```
- Keep your PEM file permissions strict (`chmod 0400`).
- Use tags for governance and cost tracking if needed.
