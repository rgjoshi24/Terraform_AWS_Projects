# Project 03: AWS VPC (Modular) – Bastion + NAT

This modular version of Project 02 splits resources into reusable modules for clarity and scalability, while keeping **SSH bastion** and **NAT Gateway** behavior identical.

## Architecture
- **VPC** `10.0.0.0/16` (DNS enabled)
- **Public Subnet** `10.0.1.0/24` (auto-assign public IPs)
- **Private Subnet** `10.0.2.0/24`
- **Internet Gateway** attached to VPC
- **Public Route Table**: `0.0.0.0/0 → IGW` (explicit route resource with dependency on IGW)
- **Private Route Table**: `0.0.0.0/0 → NAT GW`
- **NAT Gateway** (EIP) in public subnet
- **Bastion Host** (Amazon Linux 2023) in public subnet; SSH only from your IP
- **Private Host** (Amazon Linux 2023) in private subnet; SSH only from Bastion SG

## Modules
- `modules/vpc` – VPC
- `modules/network` – Subnets, IGW, RTs, NAT, routes (IGW route with depends_on; private default via NAT)
- `modules/security` – Bastion SG (SSH from your IP), Private SG (SSH from Bastion SG)
- `modules/compute` – EC2 instances with parameterized instance types and key pair

## Prerequisites
- Terraform `>= 1.5`
- AWS CLI configured with credentials
- EC2 Key Pair in `ca-central-1` (use its **name** via `key_name`, e.g., `testaws`)
- Your public IP in CIDR (e.g., `107.217.98.61/32`)

## Variables (root)
```hcl
project_name       = "tf-beginner-vpc-modular"
region             = "ca-central-1"
az                 = "ca-central-1a"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr= "10.0.2.0/24"
allowed_ssh_cidr   = "107.217.98.61/32"
key_name           = "testaws"
bastion_instance_type = "t3.micro"
private_instance_type = "t3.micro"

# Global tags
x_environment = "dev"
x_customer    = "Internal"
x_dept        = "Internal Project"
x_contact     = "test@example.com"
```

## Quick Start
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## Connect
```bash
ssh -i /path/to/testaws.pem ec2-user@$(terraform output -raw bastion_public_ip)
# From bastion
ssh ec2-user@$(terraform output -raw private_host_private_ip)
```

## Cleanup
```bash
terraform destroy -auto-approve
```

## Notes
- **Key Pair name vs path**: `key_name` must be the **AWS key pair name**; the local `.pem` path is used only in your SSH command.
- **AZ letters differ per account**; change `az` if `ca-central-1a` isn't available.
- **Costs**: NAT Gateway incurs hourly + data processing fees.
