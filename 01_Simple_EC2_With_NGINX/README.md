# Project 01: Simple EC2 with NGINX

## Overview
This project provisions a single **Amazon EC2** instance running **Amazon Linux** and installs the **NGINX** web server using `user_data`. It’s a minimal example to learn basic Terraform EC2 provisioning and cloud-init configuration.

## Features
- EC2 instance in your chosen region
- Security Group allowing **HTTP (80)** and **SSH (22)**
- `user_data` installing and starting **NGINX**
- Output of the instance **public IP**

## Prerequisites
- Terraform `>= 1.5`
- AWS CLI configured with credentials
- An existing **EC2 Key Pair** in the target region (for SSH), referenced by its **key pair name** (not the local `.pem` path)

## Quick Start
```bash
terraform init
terraform apply -auto-approve
```
**Access NGINX**: Open `http://<instance_public_ip>` in your browser.

## Typical Variables
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

## Notes
- Ensure your **key pair** exists in AWS (e.g., `testaws`), and SSH with the corresponding local PEM file:
  ```bash
  ssh -i /path/to/testaws.pem ec2-user@<instance_public_ip>
  ```
- Keep your PEM file permissions strict (`chmod 0400`).
