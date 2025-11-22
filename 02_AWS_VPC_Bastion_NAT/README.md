# Project 02: Terraform AWS Beginner VPC – Bastion + NAT

## Overview
Deploy a simple network in **`ca-central-1`**:
- **VPC** `10.0.0.0/16` with one **public** and one **private** subnet
- **Internet Gateway** attached to the VPC
- **Public Route Table**: `0.0.0.0/0 → IGW`
- **Private Route Table**: `0.0.0.0/0 → NAT GW`
- **NAT Gateway** in the public subnet
- **Bastion Host** in public subnet; SSH allowed only from **your IP**
- **Private Host** in private subnet; SSH allowed only **from Bastion SG**

![Architecture](architecture.png)

## Prerequisites
- Terraform `>= 1.5`
- AWS CLI configured with credentials
- An **EC2 Key Pair** in `ca-central-1` (use its **name** via `key_name`)
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

## Usage
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### Connect
- SSH to **Bastion**:
  ```bash
  ssh -i /path/to/testaws.pem ec2-user@<bastion_public_ip>
  ```
- From Bastion → **Private Host**:
  ```bash
  ssh ec2-user@<private_host_private_ip>
  ```

## Outputs
- `vpc_id`, `public_subnet_id`, `private_subnet_id`
- `internet_gateway_id`, `nat_gateway_id`
- `bastion_public_ip`, `private_host_private_ip`

## Cleanup
```bash
terraform destroy -auto-approve
```

## Notes
- **Key Pair name vs path**: Set `key_name` to the AWS key pair **name** (e.g., `testaws`). The local PEM file path is only used by your SSH command.
- **AZ differences**: If `ca-central-1a` is not available in your account, change `az` (e.g., to `ca-central-1b`).
- **Costs**: The **NAT Gateway** incurs hourly and data processing fees; destroy when done.
