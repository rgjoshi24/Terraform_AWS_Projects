# Terraform AWS Projects

[![Terraform](https://img.shields.io/badge/Terraform->=1.5-blue)](https://www.terraform.io/) [![AWS](https://img.shields.io/badge/AWS-Cloud-orange)](https://aws.amazon.com/)

## Overview
This repository contains beginner-friendly **Terraform projects** for deploying AWS infrastructure. Each project demonstrates key concepts of Infrastructure as Code (IaC) and AWS networking.

## Table of Contents
- [Project 01: Simple EC2 with NGINX](#project-01-simple-ec2-with-nginx)
- [Project 02: AWS VPC with Bastion & NAT](#project-02-aws-vpc-with-bastion--nat)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)
- [License](#license)

---

## Project 01: Simple EC2 with NGINX
A minimal Terraform configuration that launches a single **Amazon Linux EC2 instance**, installs **NGINX** via `user_data`, and exposes the welcome page on **HTTP (80)**.

**Highlights:**
- EC2 instance with a security group allowing **HTTP (80)** and **SSH (22)**.
- Cloud-init `user_data` installs and starts **NGINX**.
- Outputs the instance **public IP** for quick access.

[View Full Details](01_Simple_EC2_With_NGINX/README.md)

---

## Project 02: AWS VPC with Bastion & NAT
A beginner-friendly network setup in **`ca-central-1`** that creates:
- **VPC** with public and private subnets
- **Internet Gateway**, **NAT Gateway**, and route tables
- **Bastion Host** in public subnet and **Private Host** in private subnet

**Highlights:**
- Secure SSH access via Bastion
- NAT Gateway for private subnet outbound connectivity
- Tags applied to all resources for governance

[View Full Details](02_AWS_VPC_Bastion_NAT/README.md)

---

## Prerequisites
Before you begin, ensure you have:
- **Terraform**: Version `>= 1.5` installed. [Download Terraform](https://developer.hashicorp.com/terraform/downloads)
- **AWS CLI**: Installed and configured with valid credentials. [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **AWS Account**: With permissions to create VPC, EC2, NAT Gateway, and related resources.
- **EC2 Key Pair**: Pre-created in the target region for SSH access.

---

## Setup Instructions
To get started with these projects:
1. Clone the repository:
   ```bash
   git clone https://github.com/rgjoshi24/Terraform_AWS_Projects.git
   cd Terraform_AWS_Projects
   ```
2. Navigate to the desired project folder:
   - For Project 01:
     ```bash
     cd 01_Simple_EC2_With_NGINX
     ```
   - For Project 02:
     ```bash
     cd 02_AWS_VPC_Bastion_NAT
     ```
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Apply the configuration:
   ```bash
   terraform apply -auto-approve
   ```
5. Follow the project-specific README for connection and cleanup steps.

---

## Repository Structure
```
Terraform_AWS_Projects/
├── 01_Simple_EC2_With_NGINX/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── 02_AWS_VPC_Bastion_NAT/
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── architecture.png
│   └── README.md
└── README.md (this file)
```

---

## Contributing
PRs welcome! Please:
1. Keep examples **simple and reproducible**.
2. Document **prerequisites** and **cleanup** steps.
3. Use consistent **tags** and **naming**.
4. Avoid hardcoding secrets—use variables.

---

## License
This repository is licensed under the **MIT License**. You are free to use, modify, and distribute this code with proper attribution.
