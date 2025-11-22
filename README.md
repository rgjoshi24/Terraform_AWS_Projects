# Terraform AWS Projects

[![Terraform](https://img.shields.io/badge/Terraform->=1.5-blue)](https://www.terraform.io/) [![AWS](https://img.shields.io/badge/AWS-Cloud-orange)](https://aws.amazon.com/)

## Table of Contents
- [Project 01: Simple EC2 with NGINX](#project-01-simple-ec2-with-nginx)
- [Project 02: Beginner VPC with Bastion & NAT](#project-02-beginner-vpc-with-bastion--nat)

---

## Project 01: Simple EC2 with NGINX
A minimal Terraform configuration that launches a single **Amazon Linux** EC2 instance, installs **NGINX** via `user_data`, and exposes the welcome page on **HTTP (80)**.

**Highlights:**
- EC2 instance with a security group allowing **HTTP (80)** and **SSH (22)**.
- Cloud-init `user_data` installs and starts **NGINX**.
- Outputs the instance **public IP** for quick access.

[View Project 01 Details](01_Simple_EC2_With_NGINX/README.md)

---

## Project 02: Beginner VPC with Bastion & NAT
A beginner-friendly network setup in **`ca-central-1`** that creates:
- **VPC** with public and private subnets
- **Internet Gateway**, **NAT Gateway**, and route tables
- **Bastion Host** in public subnet and **Private Host** in private subnet

**Highlights:**
- Secure SSH access via Bastion
- NAT Gateway for private subnet outbound connectivity
- Tags applied to all resources for governance

[View Project 02 Details](02_AWS_VPC_Bastion_NAT/README.md)

---

## Repository Structure
```
Terraform_AWS_Projects/
├── 01_Simple_EC2_With_NGINX/
│   ├── main.tf
│   └── README.md
├── 02_tf-beginner-vpc/
│   ├── provider.tf
│   ├── main.tf
│   └── README.md
└── README.md (this file)
```
